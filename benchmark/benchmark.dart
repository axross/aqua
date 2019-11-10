import './best_hand_benchmark.dart';
import './choosing_possible_hand_matchup_benchmark.dart';
import './entire_simulation_benchmark.dart';
import './hand_power_benchmark.dart';
import './simulation_result_aggregation_benchmark.dart';

void main() {
  BestHandBenchmark().report();
  HandPowerBenchmark().report();
  ChoosingPossibleHandMatchupBenchmark().report();
  SimulationResultAggregationBenchmark().report();
  EntireSimulationBenchmark().report();
}
