import 'package:aqua/models/card.dart';
import 'package:aqua/models/card_pair.dart';
import 'package:aqua/models/hand.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/showdown.dart';
import 'package:aqua/models/suit.dart';
import 'package:test/test.dart';

void main() {
  test("Showdown#bestHands are the best hands for each player", () {
    final showdown = Showdown(
      board: {
        const Card(rank: Rank.queen, suit: Suit.spade),
        const Card(rank: Rank.jack, suit: Suit.spade),
        const Card(rank: Rank.ten, suit: Suit.spade),
        const Card(rank: Rank.seven, suit: Suit.diamond),
        const Card(rank: Rank.seven, suit: Suit.club),
      },
      holeCards: {
        CardPair(
          const Card(rank: Rank.ace, suit: Suit.spade),
          const Card(rank: Rank.king, suit: Suit.spade),
        ),
        CardPair(
          const Card(rank: Rank.queen, suit: Suit.heart),
          const Card(rank: Rank.queen, suit: Suit.diamond),
        ),
        CardPair(
          const Card(rank: Rank.ten, suit: Suit.club),
          const Card(rank: Rank.ten, suit: Suit.heart),
        ),
        CardPair(
          const Card(rank: Rank.seven, suit: Suit.heart),
          const Card(rank: Rank.seven, suit: Suit.spade),
        ),
        CardPair(
          const Card(rank: Rank.eight, suit: Suit.heart),
          const Card(rank: Rank.nine, suit: Suit.diamond),
        ),
        CardPair(
          const Card(rank: Rank.nine, suit: Suit.spade),
          const Card(rank: Rank.eight, suit: Suit.spade),
        ),
      },
    );

    expect(
      showdown.hands.elementAt(0),
      equals(Hand.bestFrom({
        const Card(rank: Rank.ace, suit: Suit.spade),
        const Card(rank: Rank.king, suit: Suit.spade),
        const Card(rank: Rank.queen, suit: Suit.spade),
        const Card(rank: Rank.jack, suit: Suit.spade),
        const Card(rank: Rank.ten, suit: Suit.spade),
      })),
    );
    expect(
      showdown.hands.elementAt(1),
      equals(Hand.bestFrom({
        const Card(rank: Rank.queen, suit: Suit.spade),
        const Card(rank: Rank.queen, suit: Suit.heart),
        const Card(rank: Rank.queen, suit: Suit.diamond),
        const Card(rank: Rank.seven, suit: Suit.diamond),
        const Card(rank: Rank.seven, suit: Suit.club),
      })),
    );
    expect(
      showdown.hands.elementAt(2),
      equals(Hand.bestFrom({
        const Card(rank: Rank.ten, suit: Suit.spade),
        const Card(rank: Rank.ten, suit: Suit.club),
        const Card(rank: Rank.ten, suit: Suit.heart),
        const Card(rank: Rank.seven, suit: Suit.diamond),
        const Card(rank: Rank.seven, suit: Suit.club),
      })),
    );
    expect(
      showdown.hands.elementAt(3),
      equals(Hand.bestFrom({
        const Card(rank: Rank.seven, suit: Suit.spade),
        const Card(rank: Rank.seven, suit: Suit.heart),
        const Card(rank: Rank.seven, suit: Suit.diamond),
        const Card(rank: Rank.seven, suit: Suit.club),
        const Card(rank: Rank.queen, suit: Suit.spade),
      })),
    );
    expect(
      showdown.hands.elementAt(4),
      equals(Hand.bestFrom({
        const Card(rank: Rank.queen, suit: Suit.spade),
        const Card(rank: Rank.jack, suit: Suit.spade),
        const Card(rank: Rank.ten, suit: Suit.spade),
        const Card(rank: Rank.nine, suit: Suit.diamond),
        const Card(rank: Rank.eight, suit: Suit.heart),
      })),
    );
    expect(
      showdown.hands.elementAt(5),
      equals(Hand.bestFrom({
        const Card(rank: Rank.queen, suit: Suit.spade),
        const Card(rank: Rank.jack, suit: Suit.spade),
        const Card(rank: Rank.ten, suit: Suit.spade),
        const Card(rank: Rank.nine, suit: Suit.spade),
        const Card(rank: Rank.eight, suit: Suit.spade),
      })),
    );
  });
}
