import 'dart:math' show max, pow;
import 'package:meta/meta.dart' show immutable;
import './card.dart' show Card, Rank, Suit;

@immutable
class Hand {
  const Hand(this.cards);

  factory Hand.bestFrom(Set<Card> cards) {
    assert(cards.length == 7);

    final _cards = cards.toList();
    Hand best;

    for (final pattern in _patterns) {
      final hand = Hand({
        _cards[pattern[0]],
        _cards[pattern[1]],
        _cards[pattern[2]],
        _cards[pattern[3]],
        _cards[pattern[4]],
      });

      if (best == null || hand.power > best.power) {
        best = hand;
      }
    }

    return best;
  }

  factory Hand.fromJson(List<Map<String, dynamic>> json) =>
      Hand.bestFrom(json.map((item) => Card.fromJson(item)).toSet());

  final Set<Card> cards;

  HandType get type {
    final countEachRank = new Map<Rank, int>();
    final countEachSuit = new Map<Suit, int>();
    var maxCount = 0;

    for (final card in cards) {
      countEachRank.update(card.rank, (count) => count + 1, ifAbsent: () => 1);
      countEachSuit.update(card.suit, (count) => count + 1, ifAbsent: () => 1);
      maxCount = max(maxCount, countEachRank[card.rank]);
    }

    final isFlush = countEachSuit.length == 1;

    if (countEachRank.length == 5) {
      final m = [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
      ];

      // AKQJT => [t,f,f,f,f,f,f,f,f,t,t,t,t,t]
      for (final rank in countEachRank.keys) {
        if (rank == Rank.ace) {
          m[0] = true;
          m[13] = true;
        } else {
          m[rank.index] = true;
        }
      }

      // mark ace as "1" (not as "14") to false if king is marked
      if (m[12]) {
        m[0] = false;
      }

      if (m.skipWhile((v) => !v).takeWhile((v) => v).length == 5) {
        return isFlush ? HandType.straightFlush : HandType.straight;
      } else {
        return isFlush ? HandType.flush : HandType.high;
      }
    } else if (countEachRank.length == 2 && maxCount == 4) {
      return HandType.fourOfAKind;
    } else if (countEachRank.length == 2 && maxCount == 3) {
      return HandType.fullhouse;
    } else if (countEachRank.length == 3 && maxCount == 3) {
      return HandType.threeOfAKind;
    } else if (countEachRank.length == 3 && maxCount == 2) {
      return HandType.twoPairs;
    } else if (countEachRank.length == 4 && maxCount == 2) {
      return HandType.aPair;
    }

    assert(false, "unreachable here.");
  }

  int get power {
    HandType type = this.type;
    int power = getHandTypePower(type);
    final countEachRank = new Map<Rank, int>();

    for (final card in cards) {
      countEachRank.update(card.rank, (count) => count + 1, ifAbsent: () => 0);
    }

    final isBottomStraight =
        (type == HandType.straightFlush || type == HandType.straight) &&
            countEachRank.containsKey(Rank.ace) &&
            countEachRank.containsKey(Rank.two);

    for (final entry in countEachRank.entries) {
      power +=
          (entry.key == Rank.ace && !isBottomStraight ? 13 : entry.key.index) *
              pow(14, entry.value);
    }

    return power;
  }

  @override
  int get hashCode => power;

  @override
  bool operator ==(Object other) =>
      other is Hand && other.cards.difference(cards).length == 0;

  List<Map<String, dynamic>> toJson() =>
      cards.map((card) => card.toJson()).toList();
}

enum HandType {
  high,
  aPair,
  twoPairs,
  threeOfAKind,
  straight,
  flush,
  fullhouse,
  fourOfAKind,
  straightFlush,
}

int getHandTypePower(HandType handType) {
  switch (handType) {
    case HandType.high:
      return _powerBaseForHandType;
    case HandType.aPair:
      return _powerBaseForHandType * 2;
    case HandType.twoPairs:
      return _powerBaseForHandType * 3;
    case HandType.threeOfAKind:
      return _powerBaseForHandType * 4;
    case HandType.straight:
      return _powerBaseForHandType * 5;
    case HandType.flush:
      return _powerBaseForHandType * 6;
    case HandType.fullhouse:
      return _powerBaseForHandType * 7;
    case HandType.fourOfAKind:
      return _powerBaseForHandType * 8;
    case HandType.straightFlush:
      return _powerBaseForHandType * 9;
  }

  assert(false, "unreachable here.");
}

// 14 ** 1 + 14 **2 + 14 ** 3 + 14 ** 4 + 14 ** 5
const _powerBaseForHandType = 579194;

const _patterns = [
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 5],
  [0, 1, 2, 3, 6],
  [0, 1, 2, 4, 5],
  [0, 1, 2, 4, 6],
  [0, 1, 2, 5, 6],
  [0, 1, 3, 4, 5],
  [0, 1, 3, 4, 6],
  [0, 1, 3, 5, 6],
  [0, 1, 4, 5, 6],
  [0, 2, 3, 4, 5],
  [0, 2, 3, 4, 6],
  [0, 2, 3, 5, 6],
  [0, 2, 4, 5, 6],
  [0, 3, 4, 5, 6],
  [1, 2, 3, 4, 5],
  [1, 2, 3, 4, 6],
  [1, 2, 3, 5, 6],
  [1, 2, 4, 5, 6],
  [1, 3, 4, 5, 6],
  [2, 3, 4, 5, 6],
];
