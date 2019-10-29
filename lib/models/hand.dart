import 'dart:math';
import 'package:aqua/models/card.dart';
import 'package:aqua/models/hand_type.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';

class Hand {
  Hand(this.cards);

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

  HandType _type;

  HandType get type {
    if (_type != null) return _type;

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
      // mark 0 and 13 for the ace to find straight
      for (final rank in countEachRank.keys) {
        if (rank == Rank.ace) {
          m[0] = true;
          m[13] = true;
        } else {
          m[rank.toInt()] = true;
        }
      }

      // unmark the ace as 0 when the king is marked
      // in order not to connect straight like as QKA23
      if (m[12]) {
        m[0] = false;
      }

      if (m.skipWhile((v) => !v).takeWhile((v) => v).length == 5) {
        _type = isFlush ? HandType.straightFlush : HandType.straight;
      } else {
        _type = isFlush ? HandType.flush : HandType.high;
      }
    } else if (countEachRank.length == 2 && maxCount == 4) {
      _type = HandType.fourOfAKind;
    } else if (countEachRank.length == 2 && maxCount == 3) {
      _type = HandType.fullHouse;
    } else if (countEachRank.length == 3 && maxCount == 3) {
      _type = HandType.threeOfAKind;
    } else if (countEachRank.length == 3 && maxCount == 2) {
      _type = HandType.twoPairs;
    } else if (countEachRank.length == 4 && maxCount == 2) {
      _type = HandType.pair;
    } else {
      assert(false, "unreachable here.");
    }

    return _type;
  }

  int _power;

  int get power {
    if (_power != null) return _power;

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
      power += (entry.key == Rank.ace && !isBottomStraight
              ? 13
              : entry.key.toInt()) *
          pow(14, entry.value);
    }

    _power = power;

    return _power;
  }

  @override
  int get hashCode => power;

  @override
  bool operator ==(Object other) =>
      other is Hand && other.cards.difference(cards).length == 0;

  List<Map<String, dynamic>> toJson() =>
      cards.map((card) => card.toJson()).toList();
}

int getHandTypePower(HandType handType) {
  if (handType == HandType.high) return _powerBaseForHandType;
  if (handType == HandType.pair) return _powerBaseForHandType * 2;
  if (handType == HandType.twoPairs) return _powerBaseForHandType * 3;
  if (handType == HandType.threeOfAKind) return _powerBaseForHandType * 4;
  if (handType == HandType.straight) return _powerBaseForHandType * 5;
  if (handType == HandType.flush) return _powerBaseForHandType * 6;
  if (handType == HandType.fullHouse) return _powerBaseForHandType * 7;
  if (handType == HandType.fourOfAKind) return _powerBaseForHandType * 8;
  if (handType == HandType.straightFlush) return _powerBaseForHandType * 9;

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
