import "dart:math" as math;
import "package:aqua/src/models/hand_range_simulation_result.dart";
import "package:flutter_test/flutter_test.dart";
import "package:poker/poker.dart";

void main() {
  group("HandRangeSimulationResult", () {
    final result = HandRangeSimulationResult(
      timesPlayed: math.pow(2, 19) - 1,
      timesAcquiredPot: math.pow(2, 0),
      timesSharedPotWithAnotherPlayer: math.pow(2, 1),
      timesSharedPotWithOtherTwoPlayers: math.pow(2, 2),
      timesSharedPotWithOtherThreePlayers: math.pow(2, 3),
      timesSharedPotWithOtherFourPlayers: math.pow(2, 4),
      timesSharedPotWithOtherFivePlayers: math.pow(2, 5),
      timesSharedPotWithOtherSixPlayers: math.pow(2, 6),
      timesSharedPotWithOtherSevenPlayers: math.pow(2, 7),
      timesSharedPotWithOtherEightPlayers: math.pow(2, 8),
      timesSharedPotWithOtherNinePlayers: math.pow(2, 9),
      timesAcquiredOrSharedPotEachHandType: {
        HandType.straightFlush: math.pow(2, 10),
        HandType.fourOfAKind: math.pow(2, 11),
        HandType.fullHouse: math.pow(2, 12),
        HandType.flush: math.pow(2, 13),
        HandType.straight: math.pow(2, 14),
        HandType.threeOfAKind: math.pow(2, 15),
        HandType.twoPairs: math.pow(2, 16),
        HandType.pair: math.pow(2, 17),
        HandType.highCard: math.pow(2, 18),
      },
    );

    test("#timesSharedPot is the sum of #timesSharedPotWithXxx", () {
      expect(result.timesSharedPot, equals(math.pow(2, 10) - 2));
    });
  });
}
