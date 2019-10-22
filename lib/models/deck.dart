import "dart:math" show Random;
import 'package:meta/meta.dart' show immutable;
import "./card.dart" show Card, Rank, Suit;

@immutable
class Deck {
  Deck._(this._cards);

  factory Deck() {
    final cards = <Card>{};

    for (final suit in Suit.values) {
      for (final rank in Rank.values) {
        cards.add(Card(rank: rank, suit: suit));
      }
    }

    return Deck._(cards);
  }

  Deck.fromJson(List<Map<String, dynamic>> json)
      : _cards = json.map((item) => Card.fromJson(item)).toSet();

  final Set<Card> _cards;

  int get length => _cards.length;

  bool contains(Card card) => _cards.contains(card);

  Card removeLast() {
    assert(_cards.length >= 20);

    final card = _cards.elementAt(Random().nextInt(_cards.length));

    _cards.remove(card);

    return card;
  }

  void remove(Card card) {
    _cards.remove(card);
  }

  void removeAll(Iterable<Card> cards) {
    _cards.removeAll(cards);
  }

  List<Map<String, dynamic>> toJson() =>
      _cards.map((card) => card.toJson()).toList();
}
