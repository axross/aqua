import "package:poker/poker.dart";

class HandRangeSimulationResult {
  HandRangeSimulationResult({
    this.timesPlayed = 0,
    this.timesAcquiredPot = 0,
    this.timesSharedPotWithAnotherPlayer = 0,
    this.timesSharedPotWithOtherTwoPlayers = 0,
    this.timesSharedPotWithOtherThreePlayers = 0,
    this.timesSharedPotWithOtherFourPlayers = 0,
    this.timesSharedPotWithOtherFivePlayers = 0,
    this.timesSharedPotWithOtherSixPlayers = 0,
    this.timesSharedPotWithOtherSevenPlayers = 0,
    this.timesSharedPotWithOtherEightPlayers = 0,
    this.timesSharedPotWithOtherNinePlayers = 0,
    Map<HandType, int> timesAcquiredOrSharedPotEachHandType,
  })  : assert(timesPlayed != null),
        assert(timesPlayed >= 0),
        assert(timesAcquiredPot != null),
        assert(timesAcquiredPot >= 0),
        assert(timesSharedPotWithAnotherPlayer != null),
        assert(timesSharedPotWithAnotherPlayer >= 0),
        assert(timesSharedPotWithOtherTwoPlayers != null),
        assert(timesSharedPotWithOtherTwoPlayers >= 0),
        assert(timesSharedPotWithOtherThreePlayers != null),
        assert(timesSharedPotWithOtherThreePlayers >= 0),
        assert(timesSharedPotWithOtherFourPlayers != null),
        assert(timesSharedPotWithOtherFourPlayers >= 0),
        assert(timesSharedPotWithOtherFivePlayers != null),
        assert(timesSharedPotWithOtherFivePlayers >= 0),
        assert(timesSharedPotWithOtherSixPlayers != null),
        assert(timesSharedPotWithOtherSixPlayers >= 0),
        assert(timesSharedPotWithOtherSevenPlayers != null),
        assert(timesSharedPotWithOtherSevenPlayers >= 0),
        assert(timesSharedPotWithOtherEightPlayers != null),
        assert(timesSharedPotWithOtherEightPlayers >= 0),
        assert(timesSharedPotWithOtherNinePlayers != null),
        assert(timesSharedPotWithOtherNinePlayers >= 0),
        assert(timesAcquiredOrSharedPotEachHandType == null ||
            (timesAcquiredOrSharedPotEachHandType != null &&
                HandType.values.every(
                    (ht) => timesAcquiredOrSharedPotEachHandType[ht] != null) &&
                timesAcquiredOrSharedPotEachHandType.values
                    .every((v) => v >= 0))),
        timesAcquiredOrSharedPotEachHandType =
            timesAcquiredOrSharedPotEachHandType ??
                {
                  HandType.straightFlush: 0,
                  HandType.fourOfAKind: 0,
                  HandType.fullHouse: 0,
                  HandType.flush: 0,
                  HandType.straight: 0,
                  HandType.threeOfAKind: 0,
                  HandType.twoPairs: 0,
                  HandType.pair: 0,
                  HandType.highCard: 0,
                };

  factory HandRangeSimulationResult.fromJson(Map<String, dynamic> json) {
    assert(json != null);

    return HandRangeSimulationResult(
      timesPlayed: json["timesPlayed"],
      timesAcquiredPot: json["timesAcquiredPot"],
      timesSharedPotWithAnotherPlayer: json["timesSharedPotWithAnotherPlayer"],
      timesSharedPotWithOtherTwoPlayers:
          json["timesSharedPotWithOtherTwoPlayers"],
      timesSharedPotWithOtherThreePlayers:
          json["timesSharedPotWithOtherThreePlayers"],
      timesSharedPotWithOtherFourPlayers:
          json["timesSharedPotWithOtherFourPlayers"],
      timesSharedPotWithOtherFivePlayers:
          json["timesSharedPotWithOtherFivePlayers"],
      timesSharedPotWithOtherSixPlayers:
          json["timesSharedPotWithOtherSixPlayers"],
      timesSharedPotWithOtherSevenPlayers:
          json["timesSharedPotWithOtherSevenPlayers"],
      timesSharedPotWithOtherEightPlayers:
          json["timesSharedPotWithOtherEightPlayers"],
      timesSharedPotWithOtherNinePlayers:
          json["timesSharedPotWithOtherNinePlayers"],
      timesAcquiredOrSharedPotEachHandType: {
        HandType.straightFlush: json["timesAcquiredOrSharedPotEachHandType"]
            ["straightFlush"],
        HandType.fourOfAKind: json["timesAcquiredOrSharedPotEachHandType"]
            ["fourOfAKind"],
        HandType.fullHouse: json["timesAcquiredOrSharedPotEachHandType"]
            ["fullHouse"],
        HandType.flush: json["timesAcquiredOrSharedPotEachHandType"]["flush"],
        HandType.straight: json["timesAcquiredOrSharedPotEachHandType"]
            ["straight"],
        HandType.threeOfAKind: json["timesAcquiredOrSharedPotEachHandType"]
            ["threeOfAKind"],
        HandType.twoPairs: json["timesAcquiredOrSharedPotEachHandType"]
            ["twoPairs"],
        HandType.pair: json["timesAcquiredOrSharedPotEachHandType"]["pair"],
        HandType.highCard: json["timesAcquiredOrSharedPotEachHandType"]
            ["highCard"],
      },
    );
  }

  int timesPlayed;

  int timesAcquiredPot;

  int timesSharedPotWithAnotherPlayer;

  int timesSharedPotWithOtherTwoPlayers;

  int timesSharedPotWithOtherThreePlayers;

  int timesSharedPotWithOtherFourPlayers;

  int timesSharedPotWithOtherFivePlayers;

  int timesSharedPotWithOtherSixPlayers;

  int timesSharedPotWithOtherSevenPlayers;

  int timesSharedPotWithOtherEightPlayers;

  int timesSharedPotWithOtherNinePlayers;

  final Map<HandType, int> timesAcquiredOrSharedPotEachHandType;

  int get timesSharedPot =>
      timesSharedPotWithAnotherPlayer +
      timesSharedPotWithOtherTwoPlayers +
      timesSharedPotWithOtherThreePlayers +
      timesSharedPotWithOtherFourPlayers +
      timesSharedPotWithOtherFivePlayers +
      timesSharedPotWithOtherSixPlayers +
      timesSharedPotWithOtherSevenPlayers +
      timesSharedPotWithOtherEightPlayers +
      timesSharedPotWithOtherNinePlayers;

  double get winRate => timesAcquiredPot / timesPlayed;

  double get tieRate => timesSharedPot / timesPlayed;

  double get equity =>
      (timesAcquiredPot +
          timesSharedPotWithAnotherPlayer / 2 +
          timesSharedPotWithOtherTwoPlayers / 3 +
          timesSharedPotWithOtherThreePlayers / 4 +
          timesSharedPotWithOtherFourPlayers / 5 +
          timesSharedPotWithOtherFivePlayers / 6 +
          timesSharedPotWithOtherSixPlayers / 7 +
          timesSharedPotWithOtherSevenPlayers / 8 +
          timesSharedPotWithOtherEightPlayers / 9 +
          timesSharedPotWithOtherNinePlayers / 10) /
      timesPlayed;

  Map<String, dynamic> toJson() => {
        "timesPlayed": timesPlayed,
        "timesAcquiredPot": timesAcquiredPot,
        "timesSharedPotWithAnotherPlayer": timesSharedPotWithAnotherPlayer,
        "timesSharedPotWithOtherTwoPlayers": timesSharedPotWithOtherTwoPlayers,
        "timesSharedPotWithOtherThreePlayers":
            timesSharedPotWithOtherThreePlayers,
        "timesSharedPotWithOtherFourPlayers":
            timesSharedPotWithOtherFourPlayers,
        "timesSharedPotWithOtherFivePlayers":
            timesSharedPotWithOtherFivePlayers,
        "timesSharedPotWithOtherSixPlayers": timesSharedPotWithOtherSixPlayers,
        "timesSharedPotWithOtherSevenPlayers":
            timesSharedPotWithOtherSevenPlayers,
        "timesSharedPotWithOtherEightPlayers":
            timesSharedPotWithOtherEightPlayers,
        "timesSharedPotWithOtherNinePlayers":
            timesSharedPotWithOtherNinePlayers,
        "timesAcquiredOrSharedPotEachHandType": {
          "straightFlush":
              timesAcquiredOrSharedPotEachHandType[HandType.straightFlush],
          "fourOfAKind":
              timesAcquiredOrSharedPotEachHandType[HandType.fourOfAKind],
          "fullHouse": timesAcquiredOrSharedPotEachHandType[HandType.fullHouse],
          "flush": timesAcquiredOrSharedPotEachHandType[HandType.flush],
          "straight": timesAcquiredOrSharedPotEachHandType[HandType.straight],
          "threeOfAKind":
              timesAcquiredOrSharedPotEachHandType[HandType.threeOfAKind],
          "twoPairs": timesAcquiredOrSharedPotEachHandType[HandType.twoPairs],
          "pair": timesAcquiredOrSharedPotEachHandType[HandType.pair],
          "highCard": timesAcquiredOrSharedPotEachHandType[HandType.highCard],
        }
      };
}
