import "package:aqua/src/models/hand_range_simulation_result.dart";
import "package:meta/meta.dart";
import "package:poker/poker.dart";

class Simulation {
  Simulation({
    @required this.communityCards,
    @required this.handRanges,
    @required this.results,
  })  : assert(handRanges != null),
        assert(communityCards != null),
        assert(results != null),
        assert(handRanges.length == results.length);

  final Set<Card> communityCards;

  final List<HandRange> handRanges;

  final List<HandRangeSimulationResult> results;

  int get timesSimulated => results.first.timesPlayed;

  @override
  String toString() {
    return "Simulation{communityCards: $communityCards, handRanges: $handRanges, results: $results}";
  }
}
