import 'package:aqua/models/card.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';
import 'package:test/test.dart';

void main() {
  test('Card can be compared with another one at their equility', () {
    expect(
        const Card(rank: Rank.ace, suit: Suit.spade) ==
            const Card(rank: Rank.ace, suit: Suit.spade),
        isTrue);
    expect(
        const Card(rank: Rank.jack, suit: Suit.club) ==
            const Card(rank: Rank.jack, suit: Suit.club),
        isTrue);
    expect(
        const Card(rank: Rank.two, suit: Suit.spade) ==
            const Card(rank: Rank.two, suit: Suit.heart),
        isFalse);
    expect(
        const Card(rank: Rank.seven, suit: Suit.spade) ==
            const Card(rank: Rank.eight, suit: Suit.spade),
        isFalse);
  });

  test('Card can be compared with another one at their order', () {
    expect(
        const Card(rank: Rank.ace, suit: Suit.spade) <
            const Card(rank: Rank.two, suit: Suit.spade),
        isTrue);
    expect(
        const Card(rank: Rank.king, suit: Suit.spade) <
            const Card(rank: Rank.ace, suit: Suit.heart),
        isTrue);
    expect(
        const Card(rank: Rank.ace, suit: Suit.spade) <
            const Card(rank: Rank.ace, suit: Suit.spade),
        isFalse);
    expect(
        const Card(rank: Rank.ace, suit: Suit.diamond) >
            const Card(rank: Rank.two, suit: Suit.spade),
        isFalse);
  });
}
