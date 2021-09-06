import "dart:async";
import "dart:isolate";
import "package:aqua/src/models/calculation.dart";
import "package:aqua/src/services/isolate_evaluation_service.dart";
import "package:poker/poker.dart";

class FlutterIsolateEvaluationService implements IsolateEvaluationService {
  Isolate? _isolate;

  SendPort? _toIsolate;

  final _streamController = StreamController<Calculation>.broadcast();

  Stream<Calculation> get onProgress => _streamController.stream;

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

  Future<void> dispose() async {
    _isolate?.kill(priority: Isolate.immediate);

    _streamController.close();
  }

  void requestEvaluation({
    required CardSet communityCards,
    required List<HandRange> players,
    required int times,
  }) {
    _toIsolate?.send([communityCards, players, times]);
  }
}

void _isolateFunction(SendPort toMain) {
  final receivePort = ReceivePort();

  receivePort.listen((data) async {
    final communityCards = data[0] as CardSet;
    final players = data[1] as List<HandRange>;
    final times = data[2] as int;
    final startedAt = DateTime.now();

    if (times % 2000 != 0) {
      toMain.send(ArgumentError.value(times, "times must be multiple of 2000"));
    }

    final evaluator = MontecarloEvaluator(
      communityCards: communityCards,
      players: players,
    );
    EvaluationResult accumulatedResult =
        EvaluationResult.empty(playerLength: players.length);

    for (int i = 1; i <= times / 2000; ++i) {
      for (final result in evaluator.take(2000)) {
        accumulatedResult += result;
      }

      toMain.send(Calculation(
        communityCards: communityCards,
        players: players,
        result: accumulatedResult,
        startedAt: startedAt,
        endedAt: DateTime.now(),
      ));
    }
  });

  toMain.send(receivePort.sendPort);
}
