import "package:aqua/src/models/hand_range_simulation_result.dart";
import "package:meta/meta.dart";
import "package:poker/poker.dart";

class Simulation {
  Simulation({
    @required this.communityCards,
    @required this.handRanges,
    @required this.results,
    @required this.startedAt,
    @required this.endedAt,
  })  : assert(handRanges != null),
        assert(communityCards != null),
        assert(results != null),
        assert(startedAt != null),
        assert(endedAt != null),
        assert(handRanges.length == results.length);

  final Set<Card> communityCards;

  final List<HandRange> handRanges;

  final List<HandRangeSimulationResult> results;

  int get timesSimulated => results.first.timesPlayed;

  final DateTime startedAt;

  final DateTime endedAt;
}
