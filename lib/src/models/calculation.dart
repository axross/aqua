import "package:meta/meta.dart";
import "package:poker/poker.dart";

@immutable
class Calculation {
  Calculation({
    required this.communityCards,
    required this.players,
    required this.result,
    required this.startedAt,
    required this.endedAt,
  });

  final CardSet communityCards;

  final List<HandRange> players;

  final EvaluationResult result;

  final DateTime startedAt;

  final DateTime endedAt;
}
