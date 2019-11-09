import 'package:aqua/models/card.dart';
import 'package:aqua/models/hand.dart';
import 'package:aqua/models/hand_type.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';
import 'package:test/test.dart';

final aceHighStraightFlush = Hand({
  Card(rank: Rank.king, suit: Suit.spade),
  Card(rank: Rank.queen, suit: Suit.spade),
  Card(rank: Rank.jack, suit: Suit.spade),
  Card(rank: Rank.ten, suit: Suit.spade),
  Card(rank: Rank.ace, suit: Suit.spade),
});
final kingHighStraightFlush = Hand({
  Card(rank: Rank.king, suit: Suit.spade),
  Card(rank: Rank.queen, suit: Suit.spade),
  Card(rank: Rank.nine, suit: Suit.spade),
  Card(rank: Rank.jack, suit: Suit.spade),
  Card(rank: Rank.ten, suit: Suit.spade),
});
final fiveHighStraightFlush = Hand({
  Card(rank: Rank.ace, suit: Suit.spade),
  Card(rank: Rank.two, suit: Suit.spade),
  Card(rank: Rank.three, suit: Suit.spade),
  Card(rank: Rank.four, suit: Suit.spade),
  Card(rank: Rank.five, suit: Suit.spade),
});
final fourOfAKindOfAce = Hand({
  Card(rank: Rank.ace, suit: Suit.spade),
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.three, suit: Suit.spade),
  Card(rank: Rank.ace, suit: Suit.club),
  Card(rank: Rank.ace, suit: Suit.diamond),
});
final fourOfAKindOfTwo = Hand({
  Card(rank: Rank.two, suit: Suit.spade),
  Card(rank: Rank.two, suit: Suit.heart),
  Card(rank: Rank.three, suit: Suit.spade),
  Card(rank: Rank.two, suit: Suit.club),
  Card(rank: Rank.two, suit: Suit.diamond),
});
final fullHouseOfJack = Hand({
  Card(rank: Rank.jack, suit: Suit.spade),
  Card(rank: Rank.two, suit: Suit.heart),
  Card(rank: Rank.jack, suit: Suit.diamond),
  Card(rank: Rank.jack, suit: Suit.club),
  Card(rank: Rank.two, suit: Suit.diamond),
});
final fullHouseOfTen = Hand({
  Card(rank: Rank.ten, suit: Suit.spade),
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.ten, suit: Suit.heart),
  Card(rank: Rank.ten, suit: Suit.club),
  Card(rank: Rank.ace, suit: Suit.spade),
});
final aceHighFlush = Hand({
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.nine, suit: Suit.diamond),
  Card(rank: Rank.queen, suit: Suit.diamond),
  Card(rank: Rank.two, suit: Suit.diamond),
  Card(rank: Rank.five, suit: Suit.diamond),
});
final jackHighFlush = Hand({
  Card(rank: Rank.jack, suit: Suit.club),
  Card(rank: Rank.nine, suit: Suit.club),
  Card(rank: Rank.three, suit: Suit.club),
  Card(rank: Rank.two, suit: Suit.club),
  Card(rank: Rank.five, suit: Suit.club),
});
final aceHighStraight = Hand({
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.king, suit: Suit.spade),
  Card(rank: Rank.queen, suit: Suit.club),
  Card(rank: Rank.jack, suit: Suit.club),
  Card(rank: Rank.ten, suit: Suit.spade),
});
final fiveHighStraight = Hand({
  Card(rank: Rank.ace, suit: Suit.spade),
  Card(rank: Rank.two, suit: Suit.spade),
  Card(rank: Rank.three, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.spade),
  Card(rank: Rank.five, suit: Suit.spade),
});
final threeOfAKindOfSeven = Hand({
  Card(rank: Rank.jack, suit: Suit.spade),
  Card(rank: Rank.seven, suit: Suit.club),
  Card(rank: Rank.three, suit: Suit.heart),
  Card(rank: Rank.seven, suit: Suit.spade),
  Card(rank: Rank.seven, suit: Suit.heart),
});
final threeOfAKindOfFour = Hand({
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.king, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.diamond),
  Card(rank: Rank.four, suit: Suit.heart),
});
final twoPairsOfAceAndKing = Hand({
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.king, suit: Suit.diamond),
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.king, suit: Suit.heart),
});
final twoPairsOfAceAndTwo = Hand({
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.two, suit: Suit.diamond),
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.two, suit: Suit.heart),
});
final twoPairsOfTenAndFive = Hand({
  Card(rank: Rank.five, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.ten, suit: Suit.diamond),
  Card(rank: Rank.ten, suit: Suit.spade),
  Card(rank: Rank.five, suit: Suit.club),
});
final pairOfAce = Hand({
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.six, suit: Suit.diamond),
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.five, suit: Suit.heart),
});
final pairOfTwo = Hand({
  Card(rank: Rank.two, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.two, suit: Suit.diamond),
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.five, suit: Suit.heart),
});
final aceHigh = Hand({
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.six, suit: Suit.diamond),
  Card(rank: Rank.ten, suit: Suit.diamond),
  Card(rank: Rank.five, suit: Suit.heart),
});
final sevenHigh = Hand({
  Card(rank: Rank.two, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.six, suit: Suit.diamond),
  Card(rank: Rank.seven, suit: Suit.diamond),
  Card(rank: Rank.five, suit: Suit.heart),
});

void main() {
  test("Hand#power is integer that is to compare with other's", () {
    expect(
      aceHighStraightFlush.power,
      equals(Hand({
        Card(rank: Rank.ace, suit: Suit.heart),
        Card(rank: Rank.king, suit: Suit.heart),
        Card(rank: Rank.queen, suit: Suit.heart),
        Card(rank: Rank.jack, suit: Suit.heart),
        Card(rank: Rank.ten, suit: Suit.heart),
      }).power),
    );
    expect(
      aceHighStraightFlush.power,
      greaterThan(kingHighStraightFlush.power),
    );
    expect(
      aceHighStraightFlush.power,
      greaterThan(fiveHighStraightFlush.power),
    );
    expect(
      fiveHighStraightFlush.power,
      greaterThan(fourOfAKindOfAce.power),
    );
    expect(
      fourOfAKindOfAce.power,
      greaterThan(fourOfAKindOfTwo.power),
    );
    expect(
      fourOfAKindOfTwo.power,
      greaterThan(fullHouseOfJack.power),
    );
    expect(
      fullHouseOfJack.power,
      greaterThan(fullHouseOfTen.power),
    );
    expect(
      fullHouseOfTen.power,
      greaterThan(aceHighFlush.power),
    );
    expect(
      aceHighFlush.power,
      greaterThan(jackHighFlush.power),
    );
    expect(
      jackHighFlush.power,
      greaterThan(aceHighStraight.power),
    );
    expect(
      aceHighStraight.power,
      greaterThan(fiveHighStraight.power),
    );
    expect(
      fiveHighStraight.power,
      greaterThan(threeOfAKindOfSeven.power),
    );
    expect(
      threeOfAKindOfSeven.power,
      greaterThan(threeOfAKindOfFour.power),
    );
    expect(
      threeOfAKindOfFour.power,
      greaterThan(twoPairsOfAceAndKing.power),
    );
    expect(
      twoPairsOfAceAndKing.power,
      greaterThan(twoPairsOfAceAndTwo.power),
    );
    expect(
      twoPairsOfAceAndTwo.power,
      greaterThan(twoPairsOfTenAndFive.power),
    );
    expect(
      twoPairsOfTenAndFive.power,
      greaterThan(pairOfAce.power),
    );
    expect(
      pairOfAce.power,
      greaterThan(pairOfTwo.power),
    );
    expect(
      pairOfTwo.power,
      greaterThan(aceHigh.power),
    );
    expect(
      aceHigh.power,
      greaterThan(sevenHigh.power),
    );
    expect(
      Hand({
        Card(rank: Rank.ace, suit: Suit.spade),
        Card(rank: Rank.king, suit: Suit.spade),
        Card(rank: Rank.king, suit: Suit.club),
        Card(rank: Rank.jack, suit: Suit.spade),
        Card(rank: Rank.seven, suit: Suit.diamond),
      }).power,
      greaterThan(Hand({
        Card(rank: Rank.king, suit: Suit.spade),
        Card(rank: Rank.king, suit: Suit.club),
        Card(rank: Rank.jack, suit: Suit.spade),
        Card(rank: Rank.queen, suit: Suit.club),
        Card(rank: Rank.ten, suit: Suit.club),
      }).power),
    );
  });

  test('Hand()#type is HandType', () {
    expect(aceHighStraightFlush.type, equals(HandType.straightFlush));
    expect(kingHighStraightFlush.type, equals(HandType.straightFlush));
    expect(fiveHighStraightFlush.type, equals(HandType.straightFlush));
    expect(fourOfAKindOfAce.type, equals(HandType.fourOfAKind));
    expect(fourOfAKindOfTwo.type, equals(HandType.fourOfAKind));
    expect(fullHouseOfJack.type, equals(HandType.fullHouse));
    expect(fullHouseOfTen.type, equals(HandType.fullHouse));
    expect(aceHighFlush.type, equals(HandType.flush));
    expect(jackHighFlush.type, equals(HandType.flush));
    expect(aceHighStraight.type, equals(HandType.straight));
    expect(fiveHighStraight.type, equals(HandType.straight));
    expect(threeOfAKindOfSeven.type, equals(HandType.threeOfAKind));
    expect(threeOfAKindOfFour.type, equals(HandType.threeOfAKind));
    expect(twoPairsOfAceAndKing.type, equals(HandType.twoPairs));
    expect(twoPairsOfAceAndTwo.type, equals(HandType.twoPairs));
    expect(twoPairsOfTenAndFive.type, equals(HandType.twoPairs));
    expect(pairOfAce.type, equals(HandType.pair));
    expect(pairOfTwo.type, equals(HandType.pair));
    expect(aceHigh.type, equals(HandType.high));
    expect(sevenHigh.type, equals(HandType.high));
  });
}
