import "package:flutter/foundation.dart";
import "package:meta/meta.dart";
import "package:poker/poker.dart";

class CommunityCardsDraft extends ChangeNotifier {
  CommunityCardsDraft(Iterable<Card?> cards)
      : assert(cards.length <= 5),
        assert(cards.every((c) => c == null || c is Card)),
        cards = [null, null, null, null, null]
          ..setRange(0, cards.length, cards);

  CommunityCardsDraft.empty() : cards = [null, null, null, null, null];

  @visibleForTesting
  final List<Card?> cards;

  int get hashCode {
    int result = 17;

    result = 37 * result + cards[0].hashCode;
    result = 37 * result + cards[1].hashCode;
    result = 37 * result + cards[2].hashCode;
    result = 37 * result + cards[3].hashCode;
    result = 37 * result + cards[4].hashCode;

    return result;
  }

  // Set<Card> toSet() => cards.where((c) => c != null).toSet();
  Set<Card> toSet() => cards.whereType<Card>().toSet();

  operator [](index) {
    assert(index != null);
    assert(index >= 0 && index < 5);

    return cards[index];
  }

  operator []=(index, card) {
    assert(index != null);
    assert(index >= 0 && index < 5);
    assert(card != null);

    cards[index] = card;
  }

  operator ==(Object other) =>
      other is CommunityCardsDraft &&
      other[0] == this[0] &&
      other[1] == this[1] &&
      other[2] == this[2] &&
      other[3] == this[3] &&
      other[4] == this[4];
}
