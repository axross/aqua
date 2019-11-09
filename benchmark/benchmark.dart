import './best_hand_benchmark.dart';
import './entire_simulation_benchmark.dart';
import './hand_power_benchmark.dart';
import 'simulation_result_aggregation_benchmark.dart';

void main() {
  BestHandBenchmark().report();
  HandPowerBenchmark().report();
  SimulationResultAggregationBenchmark().report();
  EntireSimulationBenchmark().report();
}
