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
    @required Set<Card> communityCards,
    @required List<HandRange> handRanges,
  }) {
    assert(_isolate != null);
    assert(_toIsolate != null);

    _toIsolate.send([communityCards, handRanges]);
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

  @override
  String toString() =>
      "PlayerSimulationOverallResult{win: $wins, defeats: $defeats, ties: $ties}";
}

void _isolateFunction(SendPort toMain) {
  final receivePort = ReceivePort();

  receivePort.listen((data) async {
    final communityCards = data[0] as Set<Card>;
    final handRanges = data[1] as List<HandRange>;

    final simulator = Simulator(
      communityCards: communityCards,
      handRanges: handRanges,
    );

    final results = List.generate(
      handRanges.length,
      (_) => PlayerSimulationOverallResult(),
    );

    for (int i = 1; i <= 100000; ++i) {
      Matchup matchup;

      try {
        matchup = simulator.evaluate();
      } on Exception catch (error) {
        toMain.send(error);
      }

      for (int hrIndex = 0; hrIndex < handRanges.length; ++hrIndex) {
        if (matchup.bestHandIndexes.contains(hrIndex)) {
          if (matchup.bestHandIndexes.length == 1) {
            results[hrIndex].wins += 1;
          } else {
            results[hrIndex].ties += 1;
            results[hrIndex].tiesWith[matchup.bestHandIndexes.length] += 1;
          }

          results[hrIndex].winsByHandType[matchup.hands[hrIndex].type] += 1;
        } else {
          results[hrIndex].defeats += 1;
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
