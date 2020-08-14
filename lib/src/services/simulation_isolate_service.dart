import "dart:async" show Completer, StreamController;
import "dart:isolate" show Isolate, SendPort, ReceivePort;
import "package:aqua/src/models/hand_range_simulation_result.dart";
import "package:aqua/src/models/simulation.dart";
import "package:meta/meta.dart";
import "package:poker/poker.dart";

class SimulationIsolateService {
  Isolate _isolate;

  SendPort _toIsolate;

  final _streamController = StreamController<Simulation>.broadcast();

  Stream<Simulation> get onProgress => _streamController.stream;

  void requestSimulation({
    @required Set<Card> communityCards,
    @required List<HandRange> handRanges,
    @required int times,
  }) {
    assert(_isolate != null);
    assert(_toIsolate != null);

    _toIsolate.send([communityCards, handRanges, times]);
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

void _isolateFunction(SendPort toMain) {
  final receivePort = ReceivePort();

  receivePort.listen((data) async {
    final communityCards = data[0] as Set<Card>;
    final handRanges = data[1] as List<HandRange>;
    final times = data[2] as int;

    if (times % 1000 != 0) {
      toMain.send(ArgumentError.value(times, "times must be multiple of 1000"));
    }

    final simulator = Simulator(
      communityCards: communityCards,
      handRanges: handRanges,
    );

    final results = List.generate(
        handRanges.length, (index) => HandRangeSimulationResult());

    for (int i = 1; i <= times; ++i) {
      Matchup matchup;

      try {
        matchup = simulator.evaluate();
      } on Exception catch (error) {
        toMain.send(error);
      }

      for (int hrIndex = 0; hrIndex < handRanges.length; ++hrIndex) {
        if (matchup.bestHandIndexes.contains(hrIndex)) {
          switch (matchup.bestHandIndexes.length) {
            case 1:
              results[hrIndex].timesAcquiredPot += 1;
              break;
            case 2:
              results[hrIndex].timesSharedPotWithAnotherPlayer += 1;
              break;
            case 3:
              results[hrIndex].timesSharedPotWithOtherTwoPlayers += 1;
              break;
            case 4:
              results[hrIndex].timesSharedPotWithOtherThreePlayers += 1;
              break;
            case 5:
              results[hrIndex].timesSharedPotWithOtherFourPlayers += 1;
              break;
            case 6:
              results[hrIndex].timesSharedPotWithOtherFivePlayers += 1;
              break;
            case 7:
              results[hrIndex].timesSharedPotWithOtherSixPlayers += 1;
              break;
            case 8:
              results[hrIndex].timesSharedPotWithOtherSevenPlayers += 1;
              break;
            case 9:
              results[hrIndex].timesSharedPotWithOtherEightPlayers += 1;
              break;
            case 10:
              results[hrIndex].timesSharedPotWithOtherNinePlayers += 1;
              break;
          }

          results[hrIndex].timesAcquiredOrSharedPotEachHandType[
              matchup.hands[hrIndex].type] += 1;
        }

        results[hrIndex].timesPlayed += 1;
      }

      if (i % 250 == 0) {
        toMain.send(Simulation(
          communityCards: communityCards,
          handRanges: handRanges,
          results: results,
        ));
      }
    }
  });

  toMain.send(receivePort.sendPort);
}
