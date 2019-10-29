import 'package:aqua/models/card.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';
import 'package:test/test.dart';

void main() {
  test('Card can be compared with another one at their equility', () {
    expect(
        Card(rank: Rank.ace, suit: Suit.spade) ==
            Card(rank: Rank.ace, suit: Suit.spade),
        isTrue);
    expect(
        Card(rank: Rank.jack, suit: Suit.club) ==
            Card(rank: Rank.jack, suit: Suit.club),
        isTrue);
    expect(
        Card(rank: Rank.two, suit: Suit.spade) ==
            Card(rank: Rank.two, suit: Suit.heart),
        isFalse);
    expect(
        Card(rank: Rank.seven, suit: Suit.spade) ==
            Card(rank: Rank.eight, suit: Suit.spade),
        isFalse);
  });

  test('Card can be compared with another one at their order', () {
    expect(
        Card(rank: Rank.ace, suit: Suit.spade) <
            Card(rank: Rank.two, suit: Suit.spade),
        isTrue);
    expect(
        Card(rank: Rank.king, suit: Suit.spade) <
            Card(rank: Rank.ace, suit: Suit.heart),
        isTrue);
    expect(
        Card(rank: Rank.ace, suit: Suit.spade) <
            Card(rank: Rank.ace, suit: Suit.spade),
        isFalse);
    expect(
        Card(rank: Rank.ace, suit: Suit.diamond) >
            Card(rank: Rank.two, suit: Suit.spade),
        isFalse);
  });
}
