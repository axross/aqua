import 'package:test/test.dart';
import '../../lib/models/card.dart' show Card, Rank, Suit;
import '../../lib/models/deck.dart' show Deck;

void main() {
  test("Deck is a set of 52 cards", () {
    expect(Deck().length, equals(52));
  });

  test("Deck#removeLast() removes the last Card from itself and returns it",
      () {
    final deck = Deck();
    final drawn = Set();

    for (final _ in List.filled(20, null)) {
      drawn.add(deck.removeLast());
    }

    expect(drawn.length, equals(20));
  });

  test("Deck#remove() removes the given card from itself", () {
    final deck = Deck();

    deck.remove(Card(rank: Rank.ace, suit: Suit.spade));
    deck.remove(Card(rank: Rank.two, suit: Suit.club));

    expect(deck.length, equals(50));
  });
}
