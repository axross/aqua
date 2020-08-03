import "dart:collection" show IterableMixin;
import "package:aqua/src/models/community_cards.dart";
import "package:aqua/src/models/nullable_card_pair.dart";
import "package:aqua/src/services/simulation_isolate_service.dart";
import "package:flutter/widgets.dart";
import "package:poker/poker.dart";

class SimulationSession extends InheritedWidget {
  SimulationSession({
    @required this.simulationSession,
    Widget child,
    Key key,
  })  : assert(simulationSession != null),
        super(key: key, child: child);

  final SimulationSessionData simulationSession;

  @override
  bool updateShouldNotify(SimulationSession old) =>
      simulationSession != old.simulationSession;

  static SimulationSessionData of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<SimulationSession>()
      .simulationSession;
}

class SimulationSessionData extends ChangeNotifier {
  SimulationSessionData.initial({
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

  PlayerHandSettingList _playerHandSettings;

  CommunityCards _communityCards = CommunityCards.empty();

  CommunityCards get communityCards => _communityCards;

  set communityCards(CommunityCards communityCards) {
    if (communityCards == _communityCards) {
      return;
    }

    _communityCards = communityCards;

    _clearResults();
    _enqueueSimulation();
    notifyListeners();
  }

  PlayerHandSettingList get playerHandSettings => _playerHandSettings;

  set playerHandSettings(PlayerHandSettingList playerHandSettings) {
    _playerHandSettings = playerHandSettings;

    _clearResults();
    _enqueueSimulation();
    notifyListeners();
  }

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

    final simulationIsolateService = SimulationIsolateService();

    _simulationIsolateService = simulationIsolateService;

    await simulationIsolateService.initialize();

    if (onStartSimulation != null) {
      onStartSimulation();
    }

    simulationIsolateService
      ..onProgress.listen(
        (details) {
          _hasPossibleMatchup = true;
          _results = details.results;
          _progress = details.timesSimulated / details.timesWillBeSimulated;

          notifyListeners();

          if (details.timesSimulated == details.timesWillBeSimulated) {
            simulationIsolateService.dispose();
            _simulationIsolateService = null;

            if (onFinishSimulation != null) {
              onFinishSimulation(false);
            }
          }
        },
        onError: (error) {
          simulationIsolateService.dispose();
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

class PlayerHandSettingList extends ChangeNotifier
    with IterableMixin<PlayerHandSetting> {
  PlayerHandSettingList(this._list) : assert(_list != null);

  PlayerHandSettingList.empty() : _list = [];

  final List<PlayerHandSetting> _list;

  final Map<PlayerHandSetting, Function> _listeners = {};

  int get length => _list.length;

  bool get hasIncomplete => _list.any((setting) => setting.isEmpty);

  Set<Card> get usedCards {
    final usedCards = <Card>{};

    for (final setting in _list) {
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
    _list.add(playerHandSetting);

    _listeners[playerHandSetting] = () {
      notifyListeners();
    };

    playerHandSetting.addListener(_listeners[playerHandSetting]);

    notifyListeners();
  }

  void removeAt(int index) {
    final playerHandSetting = _list.removeAt(index);

    playerHandSetting.removeListener(_listeners[playerHandSetting]);

    notifyListeners();
  }

  @override
  get iterator => _list.iterator;

  PlayerHandSetting operator [](int index) => _list[index];

  operator []=(int index, PlayerHandSetting playerHandSetting) {
    assert(index < length);

    if (_list[index] != null) {
      _list[index].removeListener(_listeners[_list[index]]);
    }

    _list[index] = playerHandSetting;

    _listeners[playerHandSetting] = () {
      notifyListeners();
    };

    playerHandSetting.addListener(_listeners[playerHandSetting]);

    notifyListeners();
  }
}

class PlayerHandSetting extends ChangeNotifier {
  PlayerHandSetting({
    @required PlayerHandSettingType type,
    @required List<NullableCardPair> holeCardPairs,
    @required Set<HandRangePart> handRange,
  })  : assert(type != null),
        assert(holeCardPairs != null),
        assert(handRange != null),
        _type = type,
        _holeCardPairs = holeCardPairs,
        _handRange = handRange;

  PlayerHandSetting.fromHandRange(this._handRange)
      : assert(_handRange != null),
        _type = PlayerHandSettingType.handRange,
        _holeCardPairs = [NullableCardPair.empty()];

  PlayerHandSetting.emptyHoleCards()
      : _type = PlayerHandSettingType.holeCards,
        _holeCardPairs = [NullableCardPair.empty()],
        _handRange = {};

  PlayerHandSetting.emptyHandRange()
      : _type = PlayerHandSettingType.handRange,
        _holeCardPairs = [NullableCardPair.empty()],
        _handRange = {};

  PlayerHandSettingType _type;

  List<NullableCardPair> _holeCardPairs;

  Set<HandRangePart> _handRange;

  PlayerHandSettingType get type => _type;

  set type(PlayerHandSettingType type) {
    if (type == _type) {
      return;
    }

    _type = type;

    if (type == PlayerHandSettingType.holeCards) {
      _handRange = {};
    }

    if (type == PlayerHandSettingType.handRange) {
      _holeCardPairs = [NullableCardPair.empty()];
    }

    notifyListeners();
  }

  NullableCardPair get firstHoleCardPair => _holeCardPairs[0];

  set firstHoleCardPair(NullableCardPair cardPair) {
    if (cardPair == _holeCardPairs[0]) {
      return;
    }

    _holeCardPairs[0] = cardPair;

    notifyListeners();
  }

  Set<HandRangePart> get handRange => _handRange;

  set handRange(Set<HandRangePart> handRange) {
    if (handRange == _handRange) {
      return;
    }

    _handRange = handRange;

    notifyListeners();
  }

  bool get isEmpty => components.isEmpty;

  Set<CardPairCombinationsGeneratable> get components {
    switch (_type) {
      case PlayerHandSettingType.holeCards:
        return _holeCardPairs
            .where((pair) => pair.isComplete)
            .map((pair) => HoleCardPair(pair[0], pair[1]))
            .toSet();
      case PlayerHandSettingType.handRange:
        return _handRange;
      case PlayerHandSettingType.mixed:
        return {
          ..._holeCardPairs
              .where((pair) => pair.isComplete)
              .map((pair) => HoleCardPair(pair[0], pair[1]))
              .toSet(),
          ..._handRange,
        };
      default:
        throw UnimplementedError();
    }
  }

  Set<CardPair> get cardPairCombinations => components.fold<Set<CardPair>>(
        {},
        (cmbs, cp) => cmbs..addAll(cp.cardPairCombinations),
      );
}

enum PlayerHandSettingType {
  holeCards,
  handRange,
  mixed,
}
