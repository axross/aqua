import "package:aqua/src/view_models/card_pair_draft.dart";
import "package:flutter/foundation.dart";
import "package:poker/poker.dart";

extension Open on HandRange {
  Set<CardPair> get onlyCardPairs => components.whereType<CardPair>().toSet();

  bool get hasCardPair => onlyCardPairs.length >= 1;

  Set<RankPair> get onlyRankPairs => components.whereType<RankPair>().toSet();

  bool get hasRankPair => onlyRankPairs.length >= 1;
}

class HandRangeDraft extends ChangeNotifier {
  HandRangeDraft({
    required HandRangeDraftInputType type,
    required List<CardPairDraft> cardPairs,
    required Set<RankPair> rankPairs,
  })  : _type = type,
        _cardPairs = cardPairs,
        _rankPairs = rankPairs;

  HandRangeDraft.emptyCardPair()
      : _type = HandRangeDraftInputType.cardPair,
        _cardPairs = [CardPairDraft.empty()],
        _rankPairs = {};

  HandRangeDraft.emptyRankPairs()
      : _type = HandRangeDraftInputType.rankPairs,
        _cardPairs = [CardPairDraft.empty()],
        _rankPairs = {};

  HandRangeDraft.fromHandRange(HandRange handRange)
      : _type = handRange.hasCardPair
            ? handRange.hasRankPair
                ? HandRangeDraftInputType.mixed
                : HandRangeDraftInputType.cardPair
            : HandRangeDraftInputType.rankPairs,
        _cardPairs = handRange.onlyCardPairs.length >= 1
            ? handRange.onlyCardPairs
                .map((cp) => CardPairDraft(cp.first, cp.last))
                .toList()
            : [CardPairDraft.empty()],
        _rankPairs = handRange.onlyRankPairs;

  HandRangeDraftInputType _type;

  List<CardPairDraft> _cardPairs;

  Set<RankPair> _rankPairs;

  HandRangeDraftInputType get type => _type;

  set type(HandRangeDraftInputType type) {
    if (type == _type) {
      return;
    }

    _type = type;

    if (type == HandRangeDraftInputType.cardPair) {
      _rankPairs = {};
    }

    if (type == HandRangeDraftInputType.rankPairs) {
      _cardPairs = [CardPairDraft.empty()];
    }

    notifyListeners();
  }

  CardPairDraft get firstCardPair => _cardPairs[0];

  set firstCardPair(CardPairDraft cardPair) {
    if (cardPair == _cardPairs[0]) {
      return;
    }

    _cardPairs[0] = cardPair;

    notifyListeners();
  }

  Set<RankPair> get rankPairs => _rankPairs;

  set rankPairs(Set<RankPair> rankPairs) {
    if (rankPairs == _rankPairs) {
      return;
    }

    _rankPairs = rankPairs;

    notifyListeners();
  }

  bool get isEmpty => toHandRange().isEmpty;

  bool get isNotEmpty => toHandRange().isNotEmpty;

  HandRange toHandRange() {
    switch (_type) {
      case HandRangeDraftInputType.cardPair:
        return HandRange(
            firstCardPair.isComplete ? {firstCardPair.toCardPair()} : {});
      case HandRangeDraftInputType.rankPairs:
        return HandRange(_rankPairs);
      case HandRangeDraftInputType.mixed:
        return HandRange({
          ..._cardPairs
              .where((cp) => cp.isComplete)
              .map((cp) => cp.toCardPair()),
          ..._rankPairs
        });
      default:
        throw UnimplementedError();
    }
  }

  @override
  String toString() {
    return "{ type: $_type, cardPairs: _cardPairs, rankPairs: _rankPairs }";
  }
}

enum HandRangeDraftInputType {
  cardPair,
  rankPairs,
  mixed,
}
