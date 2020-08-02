import "dart:math" as math;
import "package:poker/poker.dart";
import "package:aqua/src/view_models/player_hand_setting.dart";
import "package:aqua/src/services/simulation_isolate_service.dart";
import "package:flutter/widgets.dart";

class SimulationSession extends ChangeNotifier {
  SimulationSession.initial({
    this.onStartSimulation,
    this.onFinishSimulation,
  }) : _playerHandSettings = PlayerHandSettingList.empty() {
    _playerHandSettings.addListener(() {
      _clearResults();
      _enqueueSimulation();
      notifyListeners();
    });
  }

  final VoidCallback onStartSimulation;

  final void Function(bool isIntercepted) onFinishSimulation;

  final PlayerHandSettingList _playerHandSettings;

  List<Card> _communityCards = [null, null, null, null, null];

  List<Card> get communityCards => _communityCards;

  set communityCards(List<Card> cards) {
    assert(cards.length == 5);

    _communityCards = cards;

    _clearResults();
    _enqueueSimulation();
    notifyListeners();
  }

  PlayerHandSettingList get playerHandSettings => _playerHandSettings;

  List<PlayerSimulationOverallResult> _results = [];

  get results => _results;

  bool _hasPossibleMatchup = true;

  get hasPossibleMatchup => _hasPossibleMatchup;

  double _progress = 0;

  get progress => _progress;

  SimulationIsolateService _simulationIsolateService;

  void _clearResults() {
    _results = [];
    _progress = 0;
  }

  void _enqueueSimulation() async {
    if (_playerHandSettings.length <= 1) return;
    if (_playerHandSettings.hasIncomplete) return;

    if (_simulationIsolateService != null) {
      _simulationIsolateService.dispose();
      _simulationIsolateService = null;

      if (onFinishSimulation != null) {
        onFinishSimulation(true);
      }
    }

    _results = [];
    _progress = 0;

    notifyListeners();

    _simulationIsolateService = SimulationIsolateService();

    await _simulationIsolateService.initialize();

    if (onStartSimulation != null) {
      onStartSimulation();
    }

    _simulationIsolateService
      ..onProgress.listen(
        (details) {
          _hasPossibleMatchup = true;
          _results = details.results;
          _progress = details.timesSimulated / details.timesWillBeSimulated;

          notifyListeners();

          if (details.timesSimulated == details.timesWillBeSimulated) {
            _simulationIsolateService.dispose();
            _simulationIsolateService = null;

            if (onFinishSimulation != null) {
              onFinishSimulation(false);
            }
          }
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
      ..requestSimulation(
        cardPairCombinationsList: _playerHandSettings
            .toList()
            .map((setting) => setting.components)
            .toList(),
        communityCards: _communityCards.where((card) => card != null).toSet(),
      );
  }
}

class PlayerHandSettingList extends ChangeNotifier {
  PlayerHandSettingList.empty()
      : _list = List(10),
        _listeners = {};

  final List<PlayerHandSetting> _list;

  final Map<PlayerHandSettingList, Function> _listeners;

  int get length {
    final firstNullIndex = _list.indexWhere((phs) => phs == null);

    return firstNullIndex == -1 ? 10 : firstNullIndex;
  }

  bool get hasIncomplete => toList().any((setting) => setting.isEmpty);

  Set<Card> get usedCards {
    final usedCards = <Card>{};

    for (final setting in toList()) {
      if (setting.type != PlayerHandSettingType.holeCards) continue;

      if (setting.firstHoleCardPair[0] != null) {
        usedCards.add(setting.firstHoleCardPair[0]);
      }

      if (setting.firstHoleCardPair[1] != null) {
        usedCards.add(setting.firstHoleCardPair[1]);
      }
    }

    return usedCards;
  }

  void add(PlayerHandSetting playerHandSetting) {
    this[this.length] = playerHandSetting;
  }

  void removeAt(int index) {
    final removeTarget = _list[index];

    if (removeTarget != null) {
      removeTarget.removeListener(_listeners[removeTarget]);
      _listeners.remove(removeTarget);
    }

    _list.setRange(
      index,
      _list.length - 1,
      _list.sublist(index + 1, _list.length),
    );
    _list.last = null;

    notifyListeners();
  }

  List<PlayerHandSetting> toList() => _list.sublist(0, length);

  PlayerHandSetting operator [](int index) => _list[index];

  operator []=(int index, PlayerHandSetting playerHandSetting) {
    assert(index < math.min(length + 1, _list.length));

    final previous = _list[index];

    if (previous != null) {
      previous.removeListener(_listeners[previous]);
      _listeners.remove(previous);
    }

    final listener = () {
      notifyListeners();
    };

    playerHandSetting.addListener(listener);

    _list[index] = playerHandSetting;

    notifyListeners();
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
