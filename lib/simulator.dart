import "dart:math" show Random;
import 'package:aqua/card.dart';
import 'package:aqua/card_pair.dart' show CardPair;
import 'package:aqua/deck.dart' show Deck;
import 'package:aqua/showdown.dart' show Showdown;
import 'package:aqua/hand.dart' show HandType;

class Simulator {
  Iterable<Map<HandType, GameResultCount>> simulate(
    Iterable<Set<CardPair>> holeCardsEachPlayer, {
    int times = 1,
  }) {
    final results = List.generate(
        holeCardsEachPlayer.length,
        (_) => {
              HandType.high: GameResultCount(),
              HandType.aPair: GameResultCount(),
              HandType.twoPairs: GameResultCount(),
              HandType.threeOfAKind: GameResultCount(),
              HandType.straight: GameResultCount(),
              HandType.flush: GameResultCount(),
              HandType.fullhouse: GameResultCount(),
              HandType.fourOfAKind: GameResultCount(),
              HandType.straightFlush: GameResultCount(),
            });

    for (int i = 0; i < times; ++i) {
      final deck = Deck();
      final players = _getHoleCardPermutationRandomly(holeCardsEachPlayer);

      for (final holeCard in players) {
        deck.removeAll(holeCard);
      }

      final showdown = Showdown(
        board: List.generate(5, (_) => deck.removeLast()).toSet(),
        players: players,
      );
      final hands = showdown.hands.toList();

      Set<int> wonPlayers = Set<int>();
      int wonPower = 0;

      for (int i = 0; i < hands.length; ++i) {
        final hand = hands[i];

        if (hand.power > wonPower) {
          wonPlayers = {i};
          wonPower = hand.power;
        } else if (hand.power == wonPower) {
          wonPlayers.add(i);
        }
      }

      for (int p = 0; p < results.length; ++p) {
        if (wonPlayers.contains(p)) {
          if (wonPlayers.length == 1) {
            results[p][hands[p].type].won += 1;
          } else {
            results[p][hands[p].type].even += 1;
          }
        } else {
          results[p][hands[p].type].lost += 1;
        }
      }
    }

    return results;
  }
}

class GameResultCount {
  int won = 0;
  int lost = 0;
  int even = 0;
}

Iterable<CardPair> _getHoleCardPermutationRandomly(
  Iterable<Set<CardPair>> holeCardsEachPlayer,
) {
  final random = Random();
  final _holeCardsEachPlayer = holeCardsEachPlayer.toList();

  for (int i = 0; i < 100; ++i) {
    final drawn = Set<Card>();
    final cardPermutation = List<CardPair>(_holeCardsEachPlayer.length);
    final shuffledPlayerIndexes =
        _shuffle(List.generate(_holeCardsEachPlayer.length, (i) => i));

    for (final i in shuffledPlayerIndexes) {
      for (int j = 0; j < _holeCardsEachPlayer[i].length; ++j) {
        final holeCards = _holeCardsEachPlayer[i]
            .elementAt(random.nextInt(_holeCardsEachPlayer[i].length));

        if (drawn.contains(holeCards[0]) || drawn.contains(holeCards[1]))
          continue;

        cardPermutation[i] = holeCards;
        drawn.addAll(holeCards);

        break;
      }
    }

    if (cardPermutation.every((holeCard) => holeCard != null))
      return cardPermutation;
  }

  throw new Error();
}

List<T> _shuffle<T>(List<T> array) {
  final random = Random();

  for (int i = array.length - 1; i > 0; i--) {
    final j = random.nextInt(i + 1);
    final tmp = array[i];

    array[i] = array[j];
    array[j] = tmp;
  }

  return array;
}
