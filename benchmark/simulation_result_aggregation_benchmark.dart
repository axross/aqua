import 'dart:math';
import 'package:aqua/models/hand_type.dart';
import 'package:aqua/models/simulation_result.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

class SimulationResultAggregationBenchmark extends BenchmarkBase {
  SimulationResultAggregationBenchmark()
      : super('Aggregating simulation results');

  SimulationResult _simulationResult;

  SimulationResult _otherSimulationResult;

  @override
  void run() {
    _simulationResult + _otherSimulationResult;
  }

  @override
  void setup() {
    _simulationResult = SimulationResult.empty();

    final random = Random();

    final handType = HandType.values[random.nextInt(HandType.values.length)];
    final resultType = random.nextInt(3);
    final map = {
      HandType.high: SimulationResultEachHandType(
        win: 0,
        lose: 0,
        draw: 0,
      ),
      HandType.pair: SimulationResultEachHandType(
        win: 0,
        lose: 0,
        draw: 0,
      ),
      HandType.twoPairs: SimulationResultEachHandType(
        win: 0,
        lose: 0,
        draw: 0,
      ),
      HandType.threeOfAKind: SimulationResultEachHandType(
        win: 0,
        lose: 0,
        draw: 0,
      ),
      HandType.straight: SimulationResultEachHandType(
        win: 0,
        lose: 0,
        draw: 0,
      ),
      HandType.flush: SimulationResultEachHandType(
        win: 0,
        lose: 0,
        draw: 0,
      ),
      HandType.fullHouse: SimulationResultEachHandType(
        win: 0,
        lose: 0,
        draw: 0,
      ),
      HandType.fourOfAKind: SimulationResultEachHandType(
        win: 0,
        lose: 0,
        draw: 0,
      ),
      HandType.straightFlush: SimulationResultEachHandType(
        win: 0,
        lose: 0,
        draw: 0,
      ),
    };

    map[handType] = SimulationResultEachHandType(
      win: resultType == 0 ? 1 : 0,
      lose: resultType == 0 ? 1 : 0,
      draw: resultType == 0 ? 1 : 0,
    );

    _otherSimulationResult = SimulationResult.fromMap(map);
  }
}
