import 'dart:async' show Timer;
import 'package:aqua/models/card.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/player_hand_setting_preset.dart';
import 'package:aqua/models/simulation_result.dart';
import 'package:aqua/models/simulator.dart';
import 'package:aqua/services/simulation_isolate_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

class SimulationSession extends ChangeNotifier {
  SimulationSession.initial({@required FirebaseAnalytics analytics})
      : assert(analytics != null),
        _analytics = analytics,
        _board = [null, null, null, null, null],
        _playerHandSettings = [],
        _usedCards = {},
        _results = [],
        _error = null,
        _progress = 0;

  final FirebaseAnalytics _analytics;

  Set<Card> _usedCards;

  Set<Card> get usedCards => _usedCards;

  List<Card> _board;

  List<Card> get board => _board;

  setBoardAt(int index, Card card) {
    _board[index] = card;

    _refreshUsedCards();
    _enqueueSimulation();
    notifyListeners();

    _analytics.logEvent(
      name: "update_board_cards",
      parameters: {"next_length": _board.length},
    );
  }

  clearBoard() {
    _board = [null, null, null, null, null];

    _refreshUsedCards();
    _enqueueSimulation();
    notifyListeners();

    _analytics.logEvent(
      name: "update_board_cards",
      parameters: {
        "next_length": _board.length,
        "is_clear": true,
      },
    );
  }

  List<PlayerHandSetting> _playerHandSettings;

  List<PlayerHandSetting> get playerHandSettings => _playerHandSettings;

  void addPlayerHandSetting() {
    _playerHandSettings.add(PlayerHandSetting.emptyHoleCards());

    _refreshUsedCards();
    notifyListeners();

    _analytics.logEvent(
      name: "add_player_hand_setting",
    );
  }

  void removePlayerHandSettingAt(int index) {
    _playerHandSettings.removeAt(index);

    _analytics.logEvent(
      name: "delete_player_hand_setting",
    );

    _refreshUsedCards();
    _enqueueSimulation();
    notifyListeners();
  }

  void setEmptyPlayerHandSettingAt(
    int index, {
    @required PlayerHandSettingType type,
    String via,
  }) {
    if (type == PlayerHandSettingType.holeCards) {
      _setPlayerHandSettingAt(index, PlayerHandSetting.emptyHoleCards());

      return;
    }

    if (type == PlayerHandSettingType.handRange) {
      _setPlayerHandSettingAt(index, PlayerHandSetting.emptyHandRange());

      return;
    }

    throw AssertionError("unreachable here.");
  }

  void setHoleCardsAt(
    int index, {
    @required Card left,
    @required Card right,
    String via,
  }) {
    assert(_playerHandSettings[index].type == PlayerHandSettingType.holeCards);

    _setPlayerHandSettingAt(
      index,
      PlayerHandSetting.fromHoleCards(left: left, right: right),
      via: via,
    );
  }

  void setHandRangeAt(
    int index,
    Set<HandRangePart> handRange, {
    String via,
  }) {
    assert(_playerHandSettings[index].type == PlayerHandSettingType.handRange);

    _setPlayerHandSettingAt(
      index,
      PlayerHandSetting(parts: handRange),
      via: via,
    );
  }

  void setPlayerHandSettingFromPresetAt(
    int index,
    PlayerHandSettingPreset preset, {
    String via,
  }) {
    _setPlayerHandSettingAt(
      index,
      preset.toPlayerHandSetting(),
      via: via,
    );
  }

  void _setPlayerHandSettingAt(
    int index,
    PlayerHandSetting playerHandSetting, {
    String via,
  }) {
    _playerHandSettings[index] = playerHandSetting;

    _refreshUsedCards();
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
        if (via != null) ...{
          "via": via,
        },
        if (playerHandSetting.type == PlayerHandSettingType.handRange) ...{
          "length": playerHandSetting.onlyHandRange.length,
        },
      },
    );
  }

  List<SimulationResult> _results;

  get results => _results;

  SimulationCancelException _error;

  get error => _error;

  double _progress;

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
      ..._board,
      ..._playerHandSettings
          .where((playerHandSetting) =>
              playerHandSetting.type == PlayerHandSettingType.holeCards)
          .fold<Set<Card>>(
              Set<Card>(),
              (set, playerHandSetting) => set
                ..add(playerHandSetting.onlyHoleCards.left)
                ..add(playerHandSetting.onlyHoleCards.right))
    };
  }

  void _enqueueSimulation() async {
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
        "number_of_cards_in_board": _board.length,
      });
    }

    _results = [];
    _progress = 0;

    notifyListeners();

    _simulationIsolateService = SimulationIsolateService();

    await _simulationIsolateService.initialize();

    _simulationIsolateService
      ..onSimulated.listen(
        (details) {
          _error = null;
          _results = details.results;
          _progress = details.timesSimulated / details.timesWillBeSimulated;

          notifyListeners();
        },
        onError: (error) {
          _simulationIsolateService.dispose();
          _simulationIsolateService = null;

          if (error is SimulationCancelException) {
            debugPrint("simulation canceled: ${error.runtimeType}");

            this._error = error;

            notifyListeners();

            return;
          }

          throw error;
        },
      )
      ..onSimulated.first.then((_) {
        _analytics.logEvent(
          name: "receive_simulation_first_tick",
          parameters: {
            "number_of_players": _playerHandSettings.length,
            "number_of_cards_in_board": _board.length,
          },
        );
      })
      ..requestSimulation(
        playerHandSettings: _playerHandSettings.toList(),
        board: _board,
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

  static SimulationSession of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SimulationSessionProvider)
              as SimulationSessionProvider)
          .simulationSession;
}
