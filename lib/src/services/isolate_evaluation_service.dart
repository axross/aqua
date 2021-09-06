import "package:aqua/src/models/calculation.dart";
import "package:poker/poker.dart";

abstract class IsolateEvaluationService {
  Stream<Calculation> get onProgress;

  Future<void> initialize();

  Future<void> dispose();

  void requestEvaluation({
    required CardSet communityCards,
    required List<HandRange> players,
    required int times,
  });
}
