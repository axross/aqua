import "dart:collection";
import "package:aqua/src/view_models/hand_range_draft.dart";
import "package:flutter/foundation.dart";
import "package:poker/poker.dart";

class HandRangeDraftList extends ChangeNotifier with ListMixin<HandRangeDraft> {
  HandRangeDraftList.empty() : _handRangeDrafts = [];

  HandRangeDraftList.of(Iterable<HandRangeDraft> handRangeDrafts)
      : _handRangeDrafts = handRangeDrafts.toList();

  final List<HandRangeDraft> _handRangeDrafts;

  final Map<HandRangeDraft, Function> _listeners = {};

  int get length => _handRangeDrafts.length;

  bool get hasIncomplete =>
      _handRangeDrafts.any((handRange) => handRange.isEmpty);

  Set<Card> get usedCards {
    final usedCards = <Card>{};

    for (final handRangeDraft in _handRangeDrafts) {
      if (handRangeDraft.type != HandRangeDraftInputType.cardPair) {
        continue;
      }

      if (handRangeDraft.firstCardPair[0] != null) {
        usedCards.add(handRangeDraft.firstCardPair[0]);
      }

      if (handRangeDraft.firstCardPair[1] != null) {
        usedCards.add(handRangeDraft.firstCardPair[1]);
      }
    }

    return usedCards;
  }

  set length(value) {
    if (value <= length) {
      for (final handRangeDraft in _handRangeDrafts.getRange(value, length)) {
        handRangeDraft.removeListener(_listeners[handRangeDraft]);
      }

      _handRangeDrafts.length = value;

      return;
    }

    for (int i = length; i < value; ++i) {
      final handRange = HandRangeDraft.emptyCardPair();

      _handRangeDrafts.add(handRange);
      _listeners[handRange] = () {
        notifyListeners();
      };
    }
  }

  operator [](index) => _handRangeDrafts[index];

  operator []=(index, handRangeDraft) {
    assert(index < length);

    final previous = _handRangeDrafts[index];

    if (previous != null) {
      previous.removeListener(_listeners[previous]);
    }

    _handRangeDrafts[index] = handRangeDraft;

    _listeners[handRangeDraft] = () {
      notifyListeners();
    };

    handRangeDraft.addListener(_listeners[handRangeDraft]);

    notifyListeners();
  }
}
