import 'package:test/test.dart';
import '../../lib/models/card.dart' show Card, Rank, Suit;
import '../../lib/models/card_pair.dart' show CardPair;
import '../../lib/models/showdown.dart' show Showdown;
import '../../lib/models/hand.dart' show Hand;

void main() {
  test("Showdown#bestHands are the best hands for each player", () {
    final showdown = Showdown(
      board: {
        Card(rank: Rank.queen, suit: Suit.spade),
        Card(rank: Rank.jack, suit: Suit.spade),
        Card(rank: Rank.ten, suit: Suit.spade),
        Card(rank: Rank.seven, suit: Suit.diamond),
        Card(rank: Rank.seven, suit: Suit.club),
      },
      holeCards: {
        CardPair(
          Card(rank: Rank.ace, suit: Suit.spade),
          Card(rank: Rank.king, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.queen, suit: Suit.heart),
          Card(rank: Rank.queen, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.ten, suit: Suit.club),
          Card(rank: Rank.ten, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.seven, suit: Suit.heart),
          Card(rank: Rank.seven, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.nine, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.nine, suit: Suit.spade),
          Card(rank: Rank.eight, suit: Suit.spade),
        ),
      },
    );

    expect(
      showdown.hands.elementAt(0),
      equals(Hand({
        Card(rank: Rank.ace, suit: Suit.spade),
        Card(rank: Rank.king, suit: Suit.spade),
        Card(rank: Rank.queen, suit: Suit.spade),
        Card(rank: Rank.jack, suit: Suit.spade),
        Card(rank: Rank.ten, suit: Suit.spade),
      })),
    );
    expect(
      showdown.hands.elementAt(1),
      equals(Hand({
        Card(rank: Rank.queen, suit: Suit.spade),
        Card(rank: Rank.queen, suit: Suit.heart),
        Card(rank: Rank.queen, suit: Suit.diamond),
        Card(rank: Rank.seven, suit: Suit.diamond),
        Card(rank: Rank.seven, suit: Suit.club),
      })),
    );
    expect(
      showdown.hands.elementAt(2),
      equals(Hand({
        Card(rank: Rank.ten, suit: Suit.spade),
        Card(rank: Rank.ten, suit: Suit.club),
        Card(rank: Rank.ten, suit: Suit.heart),
        Card(rank: Rank.seven, suit: Suit.diamond),
        Card(rank: Rank.seven, suit: Suit.club),
      })),
    );
    expect(
      showdown.hands.elementAt(3),
      equals(Hand({
        Card(rank: Rank.seven, suit: Suit.spade),
        Card(rank: Rank.seven, suit: Suit.heart),
        Card(rank: Rank.seven, suit: Suit.diamond),
        Card(rank: Rank.seven, suit: Suit.club),
        Card(rank: Rank.queen, suit: Suit.spade),
      })),
    );
    expect(
      showdown.hands.elementAt(4),
      equals(Hand({
        Card(rank: Rank.queen, suit: Suit.spade),
        Card(rank: Rank.jack, suit: Suit.spade),
        Card(rank: Rank.ten, suit: Suit.spade),
        Card(rank: Rank.nine, suit: Suit.diamond),
        Card(rank: Rank.eight, suit: Suit.heart),
      })),
    );
    expect(
      showdown.hands.elementAt(5),
      equals(Hand({
        Card(rank: Rank.queen, suit: Suit.spade),
        Card(rank: Rank.jack, suit: Suit.spade),
        Card(rank: Rank.ten, suit: Suit.spade),
        Card(rank: Rank.nine, suit: Suit.spade),
        Card(rank: Rank.eight, suit: Suit.spade),
      })),
    );
  });
}
