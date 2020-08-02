import "dart:async";
import "dart:isolate";
import "package:poker/poker.dart";
import "package:flutter/widgets.dart";

class SimulationIsolateService {
  Isolate _isolate;

  SendPort _toIsolate;

  final _streamController = StreamController<SimulationProgress>.broadcast();

  Stream<SimulationProgress> get onProgress => _streamController.stream;

  void requestSimulation({
    @required
        List<Set<CardPairCombinationsGeneratable>> cardPairCombinationsList,
    @required Set<Card> communityCards,
  }) {
    assert(_isolate != null);
    assert(_toIsolate != null);

    _toIsolate.send([
      cardPairCombinationsList,
      communityCards,
    ]);
  }

  Future<void> initialize() async {
    final completer = Completer();
    final receivePort = ReceivePort();

    receivePort.listen((data) async {
      if (_toIsolate == null) {
        _toIsolate = data;
        completer.complete();

        return;
      }

      if (_streamController.isClosed) return;

      if (data is Exception) {
        _streamController.addError(data);
      } else {
        _streamController.add(data);
      }
    });

    _isolate = await Isolate.spawn(_isolateFunction, receivePort.sendPort);

    await completer.future;
  }

  dispose() {
    if (_isolate != null) {
      _isolate.kill(priority: Isolate.immediate);
    }

    _streamController.close();
  }
}

class SimulationProgress {
  SimulationProgress({
    @required this.timesSimulated,
    @required this.timesWillBeSimulated,
    @required this.results,
  })  : assert(timesSimulated != null),
        assert(timesWillBeSimulated != null),
        assert(results != null);

  final int timesSimulated;
  final int timesWillBeSimulated;
  final List<PlayerSimulationOverallResult> results;
}

class PlayerSimulationOverallResult {
  PlayerSimulationOverallResult();

  int wins = 0;

  int defeats = 0;

  int ties = 0;

  final tiesWith = {2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0};

  int get games => wins + defeats + ties;

  double get winRate => wins == 0 ? 0.0 : wins / games;

  double get tieRate => ties == 0 ? 0.0 : ties / games;

  double get equity =>
      winRate +
      tiesWith.entries.fold(
          0.0,
          (eq, entry) =>
              eq +
              ((entry.value == 0 ? 0.0 : (entry.value / entry.key)) / games));

  Map<HandType, int> winsByHandType =
      Map.fromEntries(HandType.values.map((type) => MapEntry(type, 0)));
}

void _isolateFunction(SendPort toMain) {
  final receivePort = ReceivePort();

  receivePort.listen((data) async {
    final cardPairCombinationsList =
        data[0] as List<Set<CardPairCombinationsGeneratable>>;
    final communityCards = data[1] as Set<Card>;

    final simulator = Simulator(
      communityCards: communityCards,
      players: cardPairCombinationsList,
    );

    final results = List.generate(cardPairCombinationsList.length,
        (_) => PlayerSimulationOverallResult());

    for (int i = 1; i <= 100000; ++i) {
      Matchup matchup;

      try {
        matchup = simulator.evaluate();
      } on Exception catch (error) {
        print(cardPairCombinationsList);

        toMain.send(error);
      }

      for (int playerIndex = 0;
          playerIndex < cardPairCombinationsList.length;
          ++playerIndex) {
        if (matchup.bestHandIndexes.contains(playerIndex)) {
          if (matchup.bestHandIndexes.length == 1) {
            results[playerIndex].wins += 1;
          } else {
            results[playerIndex].ties += 1;
            results[playerIndex].tiesWith[matchup.bestHandIndexes.length] += 1;
          }

          results[playerIndex]
              .winsByHandType[matchup.hands[playerIndex].type] += 1;
        } else {
          results[playerIndex].defeats += 1;
        }
      }

      if (i % 100 == 0) {
        toMain.send(SimulationProgress(
          timesSimulated: i,
          timesWillBeSimulated: 100000,
          results: results,
        ));
      }
    }
  });

  toMain.send(receivePort.sendPort);
}
