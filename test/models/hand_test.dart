import 'package:aqua/models/card.dart';
import 'package:aqua/models/hand.dart';
import 'package:aqua/models/hand_type.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';
import 'package:test/test.dart';

final _aceHighStraightFlush = Hand.bestFrom({
  Card(rank: Rank.king, suit: Suit.spade),
  Card(rank: Rank.queen, suit: Suit.spade),
  Card(rank: Rank.jack, suit: Suit.spade),
  Card(rank: Rank.ten, suit: Suit.spade),
  Card(rank: Rank.ace, suit: Suit.spade),
});
final _kingHighStraightFlush = Hand.bestFrom({
  Card(rank: Rank.king, suit: Suit.spade),
  Card(rank: Rank.queen, suit: Suit.spade),
  Card(rank: Rank.nine, suit: Suit.spade),
  Card(rank: Rank.jack, suit: Suit.spade),
  Card(rank: Rank.ten, suit: Suit.spade),
});
final _fiveHighStraightFlush = Hand.bestFrom({
  Card(rank: Rank.ace, suit: Suit.spade),
  Card(rank: Rank.two, suit: Suit.spade),
  Card(rank: Rank.three, suit: Suit.spade),
  Card(rank: Rank.four, suit: Suit.spade),
  Card(rank: Rank.five, suit: Suit.spade),
});
final _fourOfAKindOfAce = Hand.bestFrom({
  Card(rank: Rank.ace, suit: Suit.spade),
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.three, suit: Suit.spade),
  Card(rank: Rank.ace, suit: Suit.club),
  Card(rank: Rank.ace, suit: Suit.diamond),
});
final _fourOfAKindOfTwo = Hand.bestFrom({
  Card(rank: Rank.two, suit: Suit.spade),
  Card(rank: Rank.two, suit: Suit.heart),
  Card(rank: Rank.three, suit: Suit.spade),
  Card(rank: Rank.two, suit: Suit.club),
  Card(rank: Rank.two, suit: Suit.diamond),
});
final _fullHouseOfAce = Hand.bestFrom({
  Card(rank: Rank.king, suit: Suit.spade),
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.king, suit: Suit.diamond),
  Card(rank: Rank.king, suit: Suit.club),
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.ace, suit: Suit.spade),
});
final _fullHouseOfKing = Hand.bestFrom({
  Card(rank: Rank.king, suit: Suit.spade),
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.king, suit: Suit.diamond),
  Card(rank: Rank.king, suit: Suit.club),
  Card(rank: Rank.ace, suit: Suit.diamond),
});
final _fullHouseOfJack = Hand.bestFrom({
  Card(rank: Rank.jack, suit: Suit.spade),
  Card(rank: Rank.two, suit: Suit.heart),
  Card(rank: Rank.jack, suit: Suit.diamond),
  Card(rank: Rank.jack, suit: Suit.club),
  Card(rank: Rank.two, suit: Suit.diamond),
});
final _fullHouseOfTen = Hand.bestFrom({
  Card(rank: Rank.ten, suit: Suit.spade),
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.ten, suit: Suit.heart),
  Card(rank: Rank.ten, suit: Suit.club),
  Card(rank: Rank.ace, suit: Suit.spade),
});
final _aceHighFlush = Hand.bestFrom({
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.nine, suit: Suit.diamond),
  Card(rank: Rank.queen, suit: Suit.diamond),
  Card(rank: Rank.two, suit: Suit.diamond),
  Card(rank: Rank.five, suit: Suit.diamond),
});
final _jackHighFlush = Hand.bestFrom({
  Card(rank: Rank.jack, suit: Suit.club),
  Card(rank: Rank.nine, suit: Suit.club),
  Card(rank: Rank.three, suit: Suit.club),
  Card(rank: Rank.two, suit: Suit.club),
  Card(rank: Rank.five, suit: Suit.club),
});
final _aceHighStraight = Hand.bestFrom({
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.king, suit: Suit.spade),
  Card(rank: Rank.queen, suit: Suit.club),
  Card(rank: Rank.jack, suit: Suit.club),
  Card(rank: Rank.ten, suit: Suit.spade),
});
final _fiveHighStraight = Hand.bestFrom({
  Card(rank: Rank.ace, suit: Suit.spade),
  Card(rank: Rank.two, suit: Suit.spade),
  Card(rank: Rank.three, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.spade),
  Card(rank: Rank.five, suit: Suit.spade),
});
final _threeOfAKindOfSeven = Hand.bestFrom({
  Card(rank: Rank.jack, suit: Suit.spade),
  Card(rank: Rank.seven, suit: Suit.club),
  Card(rank: Rank.three, suit: Suit.heart),
  Card(rank: Rank.seven, suit: Suit.spade),
  Card(rank: Rank.seven, suit: Suit.heart),
});
final _threeOfAKindOfFour = Hand.bestFrom({
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.king, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.diamond),
  Card(rank: Rank.four, suit: Suit.heart),
});
final _twoPairsOfAceAndKing = Hand.bestFrom({
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.king, suit: Suit.diamond),
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.king, suit: Suit.heart),
});
final _twoPairsOfAceAndTwo = Hand.bestFrom({
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.two, suit: Suit.diamond),
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.two, suit: Suit.heart),
});
final _twoPairsOfTenAndFive = Hand.bestFrom({
  Card(rank: Rank.five, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.ten, suit: Suit.diamond),
  Card(rank: Rank.ten, suit: Suit.spade),
  Card(rank: Rank.five, suit: Suit.club),
});
final _pairOfAce = Hand.bestFrom({
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.six, suit: Suit.diamond),
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.five, suit: Suit.heart),
});
final _pairOfTwo = Hand.bestFrom({
  Card(rank: Rank.two, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.two, suit: Suit.diamond),
  Card(rank: Rank.ace, suit: Suit.diamond),
  Card(rank: Rank.five, suit: Suit.heart),
});
final _aceHigh = Hand.bestFrom({
  Card(rank: Rank.ace, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.six, suit: Suit.diamond),
  Card(rank: Rank.ten, suit: Suit.diamond),
  Card(rank: Rank.five, suit: Suit.heart),
});
final _sevenHigh = Hand.bestFrom({
  Card(rank: Rank.two, suit: Suit.heart),
  Card(rank: Rank.four, suit: Suit.club),
  Card(rank: Rank.six, suit: Suit.diamond),
  Card(rank: Rank.seven, suit: Suit.diamond),
  Card(rank: Rank.five, suit: Suit.heart),
});

void main() {
  test("Hand#power is integer that is to compare with other's", () {
    expect(
      _aceHighStraightFlush.compareStrongnessTo(Hand.bestFrom({
        Card(rank: Rank.ace, suit: Suit.heart),
        Card(rank: Rank.king, suit: Suit.heart),
        Card(rank: Rank.queen, suit: Suit.heart),
        Card(rank: Rank.jack, suit: Suit.heart),
        Card(rank: Rank.ten, suit: Suit.heart),
      })),
      equals(0),
    );

    final handsInStrongnessOrder = [
      _aceHighStraightFlush,
      _kingHighStraightFlush,
      _fiveHighStraightFlush,
      _fourOfAKindOfAce,
      _fourOfAKindOfTwo,
      _fullHouseOfAce,
      _fullHouseOfKing,
      _fullHouseOfJack,
      _fullHouseOfTen,
      _aceHighFlush,
      _jackHighFlush,
      _aceHighStraight,
      _fiveHighStraight,
      _threeOfAKindOfSeven,
      _threeOfAKindOfFour,
      _twoPairsOfAceAndKing,
      _twoPairsOfAceAndTwo,
      _twoPairsOfTenAndFive,
      _pairOfAce,
      _pairOfTwo,
      _aceHigh,
      _sevenHigh,
    ];

    expect(
        [...handsInStrongnessOrder]
          ..shuffle()
          ..sort((a, b) => b.compareStrongnessTo(a)),
        equals(handsInStrongnessOrder));

    expect(
      Hand.bestFrom({
        Card(rank: Rank.ace, suit: Suit.spade),
        Card(rank: Rank.king, suit: Suit.spade),
        Card(rank: Rank.king, suit: Suit.club),
        Card(rank: Rank.jack, suit: Suit.spade),
        Card(rank: Rank.seven, suit: Suit.diamond),
      }).compareStrongnessTo(Hand.bestFrom({
        Card(rank: Rank.king, suit: Suit.spade),
        Card(rank: Rank.king, suit: Suit.club),
        Card(rank: Rank.jack, suit: Suit.spade),
        Card(rank: Rank.queen, suit: Suit.club),
        Card(rank: Rank.ten, suit: Suit.club),
      })),
      greaterThan(0),
    );
  });

  test('Hand()#type is HandType', () {
    expect(_aceHighStraightFlush.type, equals(HandType.straightFlush));
    expect(_kingHighStraightFlush.type, equals(HandType.straightFlush));
    expect(_fiveHighStraightFlush.type, equals(HandType.straightFlush));
    expect(_fourOfAKindOfAce.type, equals(HandType.fourOfAKind));
    expect(_fourOfAKindOfTwo.type, equals(HandType.fourOfAKind));
    expect(_fullHouseOfJack.type, equals(HandType.fullHouse));
    expect(_fullHouseOfTen.type, equals(HandType.fullHouse));
    expect(_aceHighFlush.type, equals(HandType.flush));
    expect(_jackHighFlush.type, equals(HandType.flush));
    expect(_aceHighStraight.type, equals(HandType.straight));
    expect(_fiveHighStraight.type, equals(HandType.straight));
    expect(_threeOfAKindOfSeven.type, equals(HandType.threeOfAKind));
    expect(_threeOfAKindOfFour.type, equals(HandType.threeOfAKind));
    expect(_twoPairsOfAceAndKing.type, equals(HandType.twoPairs));
    expect(_twoPairsOfAceAndTwo.type, equals(HandType.twoPairs));
    expect(_twoPairsOfTenAndFive.type, equals(HandType.twoPairs));
    expect(_pairOfAce.type, equals(HandType.pair));
    expect(_pairOfTwo.type, equals(HandType.pair));
    expect(_aceHigh.type, equals(HandType.high));
    expect(_sevenHigh.type, equals(HandType.high));
  });

  test('Hand.bestFrom() returns the best hand from the given 7 cards', () {
    expect(
        Hand.bestFrom({
          Card(rank: Rank.king, suit: Suit.spade),
          Card(rank: Rank.queen, suit: Suit.spade),
          Card(rank: Rank.jack, suit: Suit.spade),
          Card(rank: Rank.ten, suit: Suit.spade),
          Card(rank: Rank.ace, suit: Suit.spade),
          Card(rank: Rank.two, suit: Suit.spade),
          Card(rank: Rank.nine, suit: Suit.spade),
        }),
        equals(_aceHighStraightFlush));
  });
}
