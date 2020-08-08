import "package:aqua/src/services/simulation_isolate_service.dart";
import "package:meta/meta.dart";
import "package:poker/poker.dart";

class SimulationSnapshot {
  SimulationSnapshot({
    @required this.communityCards,
    @required this.handRanges,
    @required this.results,
  })  : assert(handRanges != null),
        assert(communityCards != null),
        assert(results != null),
        assert(handRanges.length == results.length);

  final Set<Card> communityCards;

  final List<HandRange> handRanges;

  final List<PlayerSimulationOverallResult> results;

  @override
  String toString() {
    return "SimulationSnapshot{communityCards: $communityCards, handRanges: $handRanges, results: $results}";
  }
}
