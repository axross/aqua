import 'dart:math' show Random;
import 'dart:collection';
import 'package:flutter/foundation.dart' show ChangeNotifier, compute;
import 'package:flutter/foundation.dart';
import '../models/card.dart' show Card;
import '../models/simulation_result.dart' show SimulationResult;
import '../models/simulator.dart' show Simulator;
import '../models/player_hand_setting.dart'
    show PlayerHandSetting, PlayerHoleCards;

class SimulationSession {
  SimulationSession.initial()
      : board = ValueNotifier(<Card>[null, null, null, null, null]),
        _handSettings = SimulationHandSettings.initial(),
        results = SimulationResults.initial() {
    _handSettings.addListener(() {
      results.clear();
      _calculationCount = 0;
      _calculationId = Random().nextDouble();

      _simulate();
    });
  }

  final ValueNotifier<List<Card>> board;

  final SimulationHandSettings _handSettings;

  SimulationResults results;

  int _calculationCount = 0;

  double _calculationId;

  SimulationHandSettings get handSettings => _handSettings;

  void _simulate() async {
    if (!_handSettings.isReadyToSimulate) return;

    // print(_calculationCount);

    final handSettings = _handSettings.toList();
    final calculationId = _calculationId;
    final results = await compute(
      simulate,
      SimulateFunctionArgument(handSettings: handSettings, board: board.value),
    );

    if (calculationId == _calculationId) {
      this.results.sum(results);
      _calculationCount += 1;

      if (_calculationCount < 1000) {
        Future.microtask(() => _simulate());
      }
    }
  }
}

class SimulationHandSettings extends ChangeNotifier
    with IterableMixin<PlayerHandSetting> {
  SimulationHandSettings.initial()
      : _values = [
          PlayerHoleCards(),
          PlayerHoleCards(),
        ];

  List<PlayerHandSetting> _values;

  Iterator<PlayerHandSetting> get iterator => _values.iterator;

  bool get isFull => _values.length == 10;

  bool get isReadyToSimulate {
    final usedCards = Set<Card>();

    for (final handSetting in _values) {
      if (handSetting.cardPairCombinations.isEmpty) return false;

      if (handSetting is PlayerHoleCards) {
        if (usedCards.contains(handSetting[0])) return false;
        if (usedCards.contains(handSetting[1])) return false;

        usedCards.add(handSetting[0]);
        usedCards.add(handSetting[1]);
      }
    }

    return true;
  }

  void addEmpty() {
    _values.add(PlayerHoleCards());

    notifyListeners();
  }

  void removeAt(int index) {
    _values.removeAt(index);

    notifyListeners();
  }

  operator [](int index) => _values[index];

  operator []=(int index, PlayerHandSetting handSetting) {
    _values[index] = handSetting;

    notifyListeners();
  }
}

class SimulationResults extends ChangeNotifier
    with IterableMixin<SimulationResult> {
  SimulationResults.initial() : _values = [];

  List<SimulationResult> _values;

  Iterator<SimulationResult> get iterator => _values.iterator;

  sum(List<SimulationResult> other) {
    if (_values.isEmpty) {
      _values = other;
    } else {
      for (final entry in other.asMap().entries) {
        _values[entry.key].sum(entry.value);
      }
    }

    notifyListeners();
  }

  void clear() {
    _values = [];

    notifyListeners();
  }

  operator [](int index) {
    if (index >= _values.length) return null;

    return _values[index];
  }
}

enum SimulationInreadyReason {
  incompleteHandSetting,
  duplicateCards,
  noPossibleCombination,
}

List<SimulationResult> simulate(SimulateFunctionArgument argument) {
  final simulator = Simulator(
    handSettings: argument.handSettings,
    board: argument.board,
  );

  return simulator.simulate(times: 100);
}

class SimulateFunctionArgument {
  SimulateFunctionArgument({@required this.handSettings, @required this.board})
      : assert(handSettings != null),
        assert(board != null);

  final List<PlayerHandSetting> handSettings;
  final List<Card> board;
}

// import 'package:meta/meta.dart' show required;
// import "package:flutter/foundation.dart" show ChangeNotifier;
// import '../models/card.dart' show Card;
// import '../models/player_hand_setting.dart'
//     show PlayerHandSetting, PlayerHoleCards;
// import '../models/simulator.dart' show SimulationResult;

// class SimulationSession extends ChangeNotifier {
//   SimulationSession({List<PlayerHandSetting> handSettings})
//       : _handSettings = handSettings == null
//             ? [
//                 PlayerHoleCards(),
//                 PlayerHoleCards(),
//               ]
//             : handSettings;

//   List<PlayerHandSetting> _handSettings;

//   List<SimulationResult> _results;

//   Iterable<PlayerHandSetting> get handSettings => _handSettings;

//   set handSettings(List<PlayerHandSetting> handSettings) {
//     _handSettings = handSettings;

//     notifyListeners();
//   }

//   Iterable<SimulationResult> get results => _results;

//   set results(List<SimulationResult> results) {
//     _results = results;

//     notifyListeners();
//   }

//   get isFull => _handSettings.length == 10;

//   void addNewHandSetting() {
//     _handSettings.add(PlayerHoleCards());

//     notifyListeners();
//   }

//   // final Map<SimulationSessionPlayer, void Function()> _listeners = {};

//   // final List<SimulationSessionPlayer> _players;

//   // bool _isCalculating = false;

//   // bool get isCalculating => _isCalculating;

//   // set isCalculating(bool isCalculating) {
//   //   _isCalculating = isCalculating;

//   //   notifyListeners();
//   // }

//   // int get length => _players.length;

//   // bool get isFullPlayer => _players.length == 10;

//   // bool get isReadyToSimulate {
//   //   final usedCards = Set<Card>();

//   //   for (final player in _players) {
//   //     final handSetting = player.handSetting;

//   //     if (handSetting.cardPairCombinations.isEmpty) return false;

//   //     if (handSetting is PlayerHoleCards) {
//   //       if (usedCards.contains(handSetting[0])) return false;
//   //       if (usedCards.contains(handSetting[1])) return false;

//   //       usedCards.add(handSetting[0]);
//   //       usedCards.add(handSetting[1]);
//   //     }
//   //   }

//   //   return true;
//   // }

//   // Iterable<PlayerHandSetting> get handSettings =>
//   //     _players.map((player) => player.handSetting);

//   // void addNew() {
//   //   assert(!isFullPlayer);

//   //   final player = SimulationSessionPlayer(
//   //     handSetting: PlayerHoleCards(),
//   //   );

//   //   _players.add(player);

//   //   _registerListener(player);

//   //   notifyListeners();
//   // }

//   // void remove(SimulationSessionPlayer player) {
//   //   _players.remove(player);

//   //   _unregisterListener(player);

//   //   notifyListeners();
//   // }

//   // SimulationSessionPlayer operator [](int index) {
//   //   assert(index >= 0 && index < _players.length);

//   //   return _players[index];
//   // }

//   // operator []=(int index, SimulationSessionPlayer player) {
//   //   assert(index >= 0 && index < _players.length);

//   //   _unregisterListener(_players[index]);

//   //   _players[index] = player;

//   //   _registerListener(player);

//   //   notifyListeners();
//   // }

//   // void _registerListener(SimulationSessionPlayer player) {
//   //   final listener = () => notifyListeners();

//   //   player.addListener(listener);

//   //   _listeners[player] = listener;
//   // }

//   // void _unregisterListener(SimulationSessionPlayer player) {
//   //   final listener = _listeners[player];

//   //   player.removeListener(listener);

//   //   _listeners.remove(listener);
//   // }
// }

// // class SimulationSessionPlayer extends ChangeNotifier {
// //   SimulationSessionPlayer({@required PlayerHandSetting handSetting})
// //       : _handSetting = handSetting == null ? PlayerHoleCards() : handSetting,
// //         assert(handSetting != null);

// //   PlayerHandSetting _handSetting;

// //   SimulationResult _result;

// //   bool get hasResult => result != null;

// //   PlayerHandSetting get handSetting => _handSetting;

// //   set handSetting(PlayerHandSetting handSetting) {
// //     _result = null;
// //     _handSetting = handSetting;

// //     notifyListeners();
// //   }

// //   SimulationResult get result => _result;

// //   sumResult(SimulationResult result) {
// //     if (_result == null) {
// //       _result = result;
// //     } else {
// //       _result = _result.copyWithAdding(result);
// //     }

// //     notifyListeners();
// //   }
// // }
