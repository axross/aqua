import 'package:aqua/models/card.dart';
import 'package:aqua/models/card_pair.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';
import 'package:test/test.dart';

void main() {
  test('CardPair can be compared with another one at their equility', () {
    expect(
      CardPair(
        Card(rank: Rank.ace, suit: Suit.spade),
        Card(rank: Rank.ace, suit: Suit.heart),
      ),
      equals(CardPair(
        Card(rank: Rank.ace, suit: Suit.spade),
        Card(rank: Rank.ace, suit: Suit.heart),
      )),
    );
    expect(
      CardPair(
        Card(rank: Rank.ace, suit: Suit.spade),
        Card(rank: Rank.ace, suit: Suit.heart),
      ),
      equals(CardPair(
        Card(rank: Rank.ace, suit: Suit.heart),
        Card(rank: Rank.ace, suit: Suit.spade),
      )),
    );
    expect(
        CardPair(
              Card(rank: Rank.eight, suit: Suit.spade),
              Card(rank: Rank.nine, suit: Suit.heart),
            ) ==
            CardPair(
              Card(rank: Rank.nine, suit: Suit.spade),
              Card(rank: Rank.eight, suit: Suit.heart),
            ),
        isFalse);
  });

  test('CardPair#contains() returns bool if it includes the given Card', () {
    expect(
        CardPair(Card(rank: Rank.ace, suit: Suit.spade),
                Card(rank: Rank.ace, suit: Suit.heart))
            .contains(Card(rank: Rank.ace, suit: Suit.spade)),
        isTrue);
    expect(
        CardPair(Card(rank: Rank.jack, suit: Suit.heart),
                Card(rank: Rank.seven, suit: Suit.heart))
            .contains(Card(rank: Rank.seven, suit: Suit.heart)),
        isTrue);
    expect(
        CardPair(Card(rank: Rank.jack, suit: Suit.heart),
                Card(rank: Rank.seven, suit: Suit.heart))
            .contains(Card(rank: Rank.jack, suit: Suit.spade)),
        isFalse);
  });
}
