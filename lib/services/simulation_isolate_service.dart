import 'dart:async';
import 'dart:isolate';
import 'package:aqua/models/card.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/simulation_result.dart';
import 'package:aqua/models/simulator.dart';
import 'package:flutter/widgets.dart';

class SimulationIsolateService {
  Isolate _isolate;

  SendPort _toIsolate;

  final _streamController = StreamController<SimulationDetails>.broadcast();

  Stream<SimulationDetails> get onSimulated => _streamController.stream;

  void requestSimulation({
    @required List<PlayerHandSetting> playerHandSettings,
    @required List<Card> board,
  }) {
    assert(_isolate != null);

    _toIsolate.send([playerHandSettings, board]);
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

class SimulationDetails {
  SimulationDetails({
    @required this.timesSimulated,
    @required this.timesWillBeSimulated,
    @required this.results,
  })  : assert(timesSimulated != null),
        assert(timesWillBeSimulated != null),
        assert(results != null);

  final int timesSimulated;
  final int timesWillBeSimulated;
  final List<SimulationResult> results;
}

void _isolateFunction(SendPort toMain) {
  final receivePort = ReceivePort();

  receivePort.listen((data) async {
    final playerHandSettings = data[0] as List<PlayerHandSetting>;
    final board = data[1] as List<Card>;

    final simulator = Simulator(
      playerHandSettings: playerHandSettings,
      board: board,
    );

    var results = List.generate(
      playerHandSettings.length,
      (_) => SimulationResult.empty(),
    );

    for (int i = 0; i < _numberOfTimesOfTick; ++i) {
      final newResults = <SimulationResult>[];

      List<SimulationResult> _results;

      try {
        _results = simulator.simulate(times: _numberOfSimulationEachTick);
      } on SimulationCancelException catch (error) {
        toMain.send(error);

        break;
      }

      for (int i = 0; i < _results.length; ++i) {
        newResults.add(results[i] + _results[i]);
      }

      toMain.send(SimulationDetails(
        timesSimulated: (i + 1) * _numberOfSimulationEachTick,
        timesWillBeSimulated:
            _numberOfSimulationEachTick * _numberOfTimesOfTick,
        results: newResults,
      ));

      results = newResults;
    }
  });

  toMain.send(receivePort.sendPort);
}

const _numberOfSimulationEachTick = 250;
const _numberOfTimesOfTick = 200;
