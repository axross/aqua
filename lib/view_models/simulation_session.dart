import 'dart:async' show Timer;
import "package:poker/poker.dart";
import 'package:aqua/models/player_hand_setting_preset.dart';
import "package:aqua/view_models/player_hand_setting.dart";
import 'package:aqua/services/simulation_isolate_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

class SimulationSession extends ChangeNotifier {
  SimulationSession.initial({@required FirebaseAnalytics analytics})
      : assert(analytics != null),
        _analytics = analytics;

  final FirebaseAnalytics _analytics;

  Set<Card> _usedCards = {};

  Set<Card> get usedCards => _usedCards;

  List<Card> _communityCards = [null, null, null, null, null];

  List<Card> get communityCards => _communityCards;

  setCommunityCardAt(int index, Card card) {
    _communityCards[index] = card;

    _refreshUsedCards();
    _clearResults();
    _enqueueSimulation();
    notifyListeners();

    _analytics.logEvent(
      name: "update_communityCards_cards",
      parameters: {"next_length": _communityCards.length},
    );
  }

  clearCommunityCards() {
    _communityCards = [null, null, null, null, null];

    _refreshUsedCards();
    _clearResults();
    _enqueueSimulation();
    notifyListeners();

    _analytics.logEvent(
      name: "update_communityCards_cards",
      parameters: {
        "next_length": _communityCards.length,
        "is_clear": true,
      },
    );
  }

  List<PlayerHandSetting> _playerHandSettings = [];

  List<PlayerHandSetting> get playerHandSettings => _playerHandSettings;

  final _playerHandSettingListners = <int, Function>{};

  void addPlayerHandSetting() {
    // hole cards by the default
    final playerHandSetting = PlayerHandSetting.emptyHoleCards();
    final listener = () {
      _refreshUsedCards();
      _clearResults();
      _enqueueSimulation();
      notifyListeners();
    };

    playerHandSetting.addListener(listener);

    _playerHandSettings.add(playerHandSetting);
    _playerHandSettingListners[_playerHandSettings.indexOf(playerHandSetting)] =
        listener;

    _refreshUsedCards();
    _clearResults();
    _enqueueSimulation();
    notifyListeners();

    _analytics.logEvent(name: "add_player_hand_setting");
  }

  void removePlayerHandSettingAt(int index) {
    final playerHandSetting = _playerHandSettings[index];

    playerHandSetting.removeListener(_playerHandSettingListners[index]);
    _playerHandSettings.removeAt(index);
    _results = [];

    _refreshUsedCards();
    _clearResults();
    _enqueueSimulation();
    notifyListeners();

    _analytics.logEvent(name: "delete_player_hand_setting");
  }

  void setInitialHoleCardPairAt(
    int index,
    Card left,
    Card right, {
    String via,
  }) {
    _playerHandSettings[index].holeCardPairs = [
      ..._playerHandSettings[index].holeCardPairs
    ]..first = NullableCardPair(left, right);

    _refreshUsedCards();
    _clearResults();
    _enqueueSimulation();
    notifyListeners();

    _analytics.logEvent(
      name: "update_player_hand_setting",
      parameters: {
        "type": "hole_cards",
        if (via != null) ...{"via": via},
      },
    );
  }

  void setHandRangeAt(
    int index,
    Set<HandRangePart> handRange, {
    String via,
  }) {
    _playerHandSettings[index].handRange = handRange;

    _refreshUsedCards();
    _clearResults();
    _enqueueSimulation();
    notifyListeners();

    _analytics.logEvent(
      name: "update_player_hand_setting",
      parameters: {
        "type": "hand_range",
        "length": handRange.length,
        if (via != null) ...{"via": via},
      },
    );
  }

  void setPlayerHandSettingFromPresetAt(
    int index,
    PlayerHandSettingPreset preset, {
    String via,
  }) {
    final playerHandSetting = preset.toPlayerHandSetting();

    _playerHandSettings[index] = playerHandSetting;

    _refreshUsedCards();
    _clearResults();
    _enqueueSimulation();
    notifyListeners();

    _analytics.logEvent(
      name: "update_player_hand_setting",
      parameters: {
        "type": (() {
          switch (playerHandSetting.type) {
            case PlayerHandSettingType.holeCards:
              return "hole_cards";
            case PlayerHandSettingType.handRange:
              return "hand_range";
          }

          throw AssertionError("unreachable here.");
        })(),
        if (via != null) ...{"via": via},
      },
    );
  }

  List<PlayerSimulationOverallResult> _results = [];

  get results => _results;

  bool _hasPossibleMatchup = true;

  get hasPossibleMatchup => _hasPossibleMatchup;

  get hasImcompletePlayerSetting =>
      _playerHandSettings.any((setting) => setting.isEmpty);

  double _progress = 0;

  get progress => _progress;

  int _lockCount = 0;
  bool _isEnqueuedWhileLock = false;

  void lockStartingSimulation() {
    _lockCount += 1;
  }

  void unlockStartingSimulation() {
    assert(_lockCount >= 1);

    _lockCount -= 1;

    if (_lockCount == 0 && _isEnqueuedWhileLock) {
      _isEnqueuedWhileLock = false;

      _enqueueSimulation();
    }
  }

  SimulationIsolateService _simulationIsolateService;

  Timer _timer;

  void _refreshUsedCards() {
    _usedCards = {
      ..._communityCards,
      ..._playerHandSettings
          .where((playerHandSetting) =>
              playerHandSetting.type == PlayerHandSettingType.holeCards &&
              playerHandSetting.holeCardPairs.isNotEmpty)
          .fold<Set<Card>>(
              Set<Card>(),
              (set, playerHandSetting) => set
                ..add(playerHandSetting.holeCardPairs.first[0])
                ..add(playerHandSetting.holeCardPairs.first[1]))
    };
  }

  void _clearResults() {
    _results = [];
    _progress = 0;
  }

  void _enqueueSimulation() async {
    if (_playerHandSettings.length <= 1) return;
    if (hasImcompletePlayerSetting) return;

    if (_lockCount >= 1) {
      _isEnqueuedWhileLock = true;

      return;
    }

    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }

    if (_simulationIsolateService != null) {
      _simulationIsolateService.dispose();

      _analytics.logEvent(name: "end_simulation", parameters: {
        "number_of_players": _playerHandSettings.length,
        "number_of_cards_in_communityCards": _communityCards.length,
      });
    }

    _results = [];
    _progress = 0;

    notifyListeners();

    _simulationIsolateService = SimulationIsolateService();

    await _simulationIsolateService.initialize();

    _simulationIsolateService
      ..onProgress.listen(
        (details) {
          _hasPossibleMatchup = true;
          _results = details.results;
          _progress = details.timesSimulated / details.timesWillBeSimulated;

          notifyListeners();
        },
        onError: (error) {
          _simulationIsolateService.dispose();
          _simulationIsolateService = null;

          if (error is NoPossibleMatchupException) {
            debugPrint("simulation canceled: ${error.runtimeType}");

            _hasPossibleMatchup = false;

            notifyListeners();

            return;
          }

          throw error;
        },
      )
      ..onProgress.first.then((_) {
        _analytics.logEvent(
          name: "receive_simulation_first_tick",
          parameters: {
            "number_of_players": _playerHandSettings.length,
            "number_of_cards_in_communityCards": _communityCards.length,
          },
        );
      })
      ..requestSimulation(
        cardPairCombinationsList:
            _playerHandSettings.map((setting) => setting.components).toList(),
        communityCards: _communityCards.where((card) => card != null).toSet(),
      );
  }
}

class SimulationSessionProvider extends InheritedWidget {
  SimulationSessionProvider({
    @required this.simulationSession,
    Widget child,
    Key key,
  })  : assert(simulationSession != null),
        super(key: key, child: child);

  final SimulationSession simulationSession;

  @override
  bool updateShouldNotify(SimulationSessionProvider old) =>
      simulationSession != old.simulationSession;

  static SimulationSession of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<SimulationSessionProvider>()
      .simulationSession;
}
