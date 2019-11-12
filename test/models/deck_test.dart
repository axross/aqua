import 'dart:math';
import 'package:aqua/models/card.dart';
import 'package:aqua/models/deck.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';
import 'package:test/test.dart';

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

  test("Deck#shuffle() shuffles the cards", () {
    final counts = Map();

    for (int i = 0; i < 1000000; ++i) {
      final deck = Deck();

      deck.shuffle();

      for (final card in deck.take(5)) {
        counts.update(card, (count) => count + 1, ifAbsent: () => 1);
      }
    }

    int minimum = 1000000;
    int maximum = 0;

    for (final count in counts.values) {
      minimum = min(minimum, count);
      maximum = max(maximum, count);
    }

    expect((maximum - minimum).abs(), lessThan(3000));
  });

  test("Deck#shuffle() shuffles the cards (when some cards omitted)", () {
    final counts = Map();

    for (int i = 0; i < 1000000; ++i) {
      final deck = Deck();

      deck.remove(const Card(rank: Rank.ace, suit: Suit.spade));
      deck.remove(const Card(rank: Rank.seven, suit: Suit.diamond));
      deck.remove(const Card(rank: Rank.queen, suit: Suit.club));
      deck.remove(const Card(rank: Rank.ten, suit: Suit.club));

      deck.shuffle();

      for (final card in deck.take(5)) {
        counts.update(card, (count) => count + 1, ifAbsent: () => 1);
      }
    }

    int minimum = 1000000;
    int maximum = 0;

    for (final count in counts.values) {
      minimum = min(minimum, count);
      maximum = max(maximum, count);
    }

    expect((maximum - minimum).abs(), lessThan(3000));
  });
}
