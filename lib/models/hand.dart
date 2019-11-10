import 'dart:collection';
import 'dart:math' as math;
import 'package:aqua/models/card.dart';
import 'package:aqua/models/hand_type.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';
import 'package:meta/meta.dart';

List<Card> chooseFlushCards(List<Card> sortedCards) {
  final cardsEachSuit = LinkedHashMap<Suit, List<Card>>();

  for (final card in sortedCards) {
    cardsEachSuit.update(
      card.suit,
      (v) => v..add(card),
      ifAbsent: () => [card],
    );
  }

  for (final cards in cardsEachSuit.values) {
    if (cards.length < 5) continue;

    return cards;
  }

  return null;
}

List<Card> chooseStraightCards(List<Card> sortedCards, {Suit forSuit}) {
  final cardsEachRank = LinkedHashMap<Rank, List<Card>>();

  for (final card in sortedCards) {
    if (forSuit != null && card.suit != forSuit) continue;

    cardsEachRank.update(
      card.rank,
      (v) => v..add(card),
      ifAbsent: () => [card],
    );
  }

  if (cardsEachRank.length >= 5) {
    final firstCardsEachRank =
        cardsEachRank.map((rank, cards) => MapEntry(rank, cards.first));
    final ranks = firstCardsEachRank.values.map((card) => card.rank).toSet();

    for (final combination in straightRankCombinations) {
      final intersection = ranks.intersection(combination);

      if (intersection.length >= 5) {
        final _cards = <Card>[];

        for (final rank in intersection) {
          _cards.add(firstCardsEachRank[rank]);
        }

        assert(_cards.length == 5);

        if (combination == straightRankCombinations.last) {
          return _cards..sort((a, b) => b.rank.compareTo(a.rank));
        }

        return _cards..sort((a, b) => b.rank.compareStrongnessTo(a.rank));
      }
    }
  }

  return null;
}

class Hand {
  Hand({@required List<Card> cards, @required this.type})
      : assert(cards != null),
        assert(type != null),
        _cards = cards,
        _power = calculateHandPower(cards, type);

  factory Hand.bestFrom(Iterable<Card> cards) {
    assert(cards.length <= 7);

    final sortedCards = cards.toList()
      ..sort((a, b) {
        if (a.rank != b.rank) return b.rank.compareStrongnessTo(a.rank);

        return a.suit.compareTo(b.suit);
      });
    final cardsEachRank = LinkedHashMap<Rank, List<Card>>();
    final numberOfCardsEachRank = LinkedHashMap<Rank, int>();

    for (final card in sortedCards) {
      cardsEachRank.update(
        card.rank,
        (v) => v..add(card),
        ifAbsent: () => [card],
      );
      numberOfCardsEachRank.update(card.rank, (v) => v + 1, ifAbsent: () => 1);
    }

    List<Card> flushCards = chooseFlushCards(sortedCards);
    List<Card> straightCards = chooseStraightCards(
          sortedCards,
          forSuit: flushCards == null ? null : flushCards.first.suit,
        ) ??
        chooseStraightCards(sortedCards);

    if (numberOfCardsEachRank.containsValue(4)) {
      final chosenCards = cardsEachRank.entries
          .where((entry) => entry.value.length == 4)
          .map((entry) => entry.value)
          .first;

      for (final _cards in cardsEachRank.values) {
        if (_cards.length == 4) continue;

        chosenCards.add(_cards.first);

        break;
      }

      return Hand(cards: chosenCards, type: HandType.fourOfAKind);
    }

    if (numberOfCardsEachRank.containsValue(3)) {
      List<Card> chosenCards;

      for (final _cards in cardsEachRank.values) {
        if (_cards.length != 3) continue;

        chosenCards = _cards;

        break;
      }

      for (final _cards in cardsEachRank.values) {
        if (_cards.length < 2) continue;
        if (_cards == chosenCards) continue;

        chosenCards.addAll(_cards.take(2));

        break;
      }

      if (chosenCards.length == 5) {
        return Hand(cards: chosenCards, type: HandType.fullHouse);
      }
    }

    // evaluate straight prior because it can be straight flush
    if (straightCards != null) {
      if (flushCards != null && flushCards.toSet().containsAll(straightCards)) {
        return Hand(cards: straightCards, type: HandType.straightFlush);
      }

      return Hand(cards: straightCards, type: HandType.straight);
    }

    if (flushCards != null) {
      return Hand(cards: flushCards.take(5).toList(), type: HandType.flush);
    }

    if (numberOfCardsEachRank.containsValue(3)) {
      final cardsOfThreeOfKind =
          cardsEachRank.values.firstWhere((cards) => cards.length == 3);
      final chosenCards = [...cardsOfThreeOfKind];

      for (final _cards in cardsEachRank.values) {
        if (_cards == cardsOfThreeOfKind) continue;

        chosenCards.add(_cards.first);

        if (chosenCards.length == 5) break;
      }

      return Hand(cards: chosenCards, type: HandType.threeOfAKind);
    }

    if (numberOfCardsEachRank.values.where((value) => value == 2).length >= 2) {
      final alreadyChosen = Set<List<Card>>();
      final chosenCards = <Card>[];

      for (final _cards in cardsEachRank.values) {
        if (_cards.length != 2) continue;

        chosenCards.addAll(_cards);
        alreadyChosen.add(_cards);

        if (chosenCards.length == 4) break;
      }

      for (final _cards in cardsEachRank.values) {
        if (alreadyChosen.contains(_cards)) continue;

        chosenCards.add(_cards.first);

        break;
      }

      return Hand(cards: chosenCards, type: HandType.twoPairs);
    }

    if (numberOfCardsEachRank.containsValue(2)) {
      final chosenCards = <Card>[];
      List<Card> chosenPair;

      for (final _cards in cardsEachRank.values) {
        if (_cards.length != 2) continue;

        chosenCards.addAll(_cards);
        chosenPair = _cards;

        if (chosenCards.length == 2) break;
      }

      for (final _cards in cardsEachRank.values) {
        if (_cards == chosenPair) continue;

        chosenCards.add(_cards.first);

        if (chosenCards.length == 5) break;
      }

      return Hand(cards: chosenCards, type: HandType.pair);
    }

    return Hand(
      cards: cardsEachRank.values.map((value) => value.first).take(5).toList(),
      type: HandType.high,
    );
  }

  final List<Card> _cards;

  Set<Card> get cards => _cards.toSet();

  final HandType type;

  final int _power;

  int compareStrongnessTo(Hand other) => _power - other._power;

  @override
  int get hashCode => _power;

  @override
  bool operator ==(Object other) =>
      other is Hand && other.cards.difference(cards).length == 0;
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

  throw AssertionError("unreachable here.");
}

int calculateHandPower(List<Card> cards, HandType type) {
  final isBottomStraight =
      (type == HandType.straightFlush || type == HandType.straight) &&
          cards[0].rank == Rank.five;

  return getHandTypePower(type) +
      (cards[0].rank == Rank.ace && !isBottomStraight
              ? 13
              : cards[0].rank.toInt()) *
          math.pow(13, 4) +
      (cards[1].rank == Rank.ace && !isBottomStraight
              ? 13
              : cards[1].rank.toInt()) *
          math.pow(13, 3) +
      (cards[2].rank == Rank.ace && !isBottomStraight
              ? 13
              : cards[2].rank.toInt()) *
          math.pow(13, 2) +
      (cards[3].rank == Rank.ace && !isBottomStraight
              ? 13
              : cards[3].rank.toInt()) *
          math.pow(13, 1) +
      (cards[4].rank == Rank.ace && !isBottomStraight
              ? 13
              : cards[4].rank.toInt()) *
          math.pow(13, 0);
}

// 13 * 13 ** 4 + 13 * 13 ** 3 + 13 * 13 ** 2 + 13 * 13 ** 1 + 13 * 13 ** 0
const _powerBaseForHandType = 100402233;

final straightRankCombinations = [
  {Rank.ace, Rank.king, Rank.queen, Rank.jack, Rank.ten},
  {Rank.king, Rank.queen, Rank.jack, Rank.ten, Rank.nine},
  {Rank.queen, Rank.jack, Rank.ten, Rank.nine, Rank.eight},
  {Rank.jack, Rank.ten, Rank.nine, Rank.eight, Rank.seven},
  {Rank.ten, Rank.nine, Rank.eight, Rank.seven, Rank.six},
  {Rank.nine, Rank.eight, Rank.seven, Rank.six, Rank.five},
  {Rank.eight, Rank.seven, Rank.six, Rank.five, Rank.four},
  {Rank.seven, Rank.six, Rank.five, Rank.four, Rank.three},
  {Rank.six, Rank.five, Rank.four, Rank.three, Rank.two},
  {Rank.five, Rank.four, Rank.three, Rank.two, Rank.ace},
];
