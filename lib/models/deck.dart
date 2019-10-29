import 'dart:collection';
import "dart:math";
import 'package:aqua/models/card.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';

class Deck extends IterableBase<Card> {
  Deck._(this._cards);

  factory Deck() {
    final cards = <Card>[];

    for (final suit in Suit.values) {
      for (final rank in Rank.values) {
        cards.add(Card(rank: rank, suit: suit));
      }
    }

    return Deck._(cards);
  }

  final List<Card> _cards;

  @override
  Iterator<Card> get iterator => _cards.iterator;

  Card removeLast() {
    assert(_cards.length >= 20);

    final card = _cards.elementAt(Random().nextInt(_cards.length));

    _cards.remove(card);

    return card;
  }

  void remove(Card card) {
    _cards.remove(card);
  }

  void shuffle() {
    _cards.shuffle();
  }
}
