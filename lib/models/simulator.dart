import "dart:math" show Random;
import 'package:meta/meta.dart' show immutable;
import './card.dart' show Card;
import './card_pair.dart' show CardPair;
import './deck.dart' show Deck;
import './hand.dart' show HandType;
import './player_hand_setting.dart' show PlayerHandSetting;
import './showdown.dart' show Showdown;

class Simulator {
  Simulator(this.players)
      : holeCardsEachPlayer =
            players.map((player) => player.cardPairCombinations).toList();

  final List<PlayerHandSetting> players;
  final List<Set<CardPair>> holeCardsEachPlayer;

  List<SimulationResult> simulate({int times = 1}) {
    final results =
        List.generate(players.length, (_) => _MutableSimulationResult());

    for (int i = 0; i < times; ++i) {
      final deck = Deck();
      final holeCards = _getHoleCardPermutationRandomly(holeCardsEachPlayer);

      for (final holeCard in holeCards) {
        deck.removeAll(holeCard);
      }

      final showdown = Showdown(
        board: List.generate(5, (_) => deck.removeLast()).toSet(),
        holeCards: holeCards,
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
            results[p].resultEachHandType[hands[p].type].win += 1;
          } else {
            results[p].resultEachHandType[hands[p].type].even += 1;
          }
        } else {
          results[p].resultEachHandType[hands[p].type].lose += 1;
        }
      }
    }

    return results
        .map<SimulationResult>((result) => result.toImmutable())
        .toList();
  }
}

@immutable
class SimulationResult {
  SimulationResult(
      {Map<HandType, SimulationResultEachHandType> resultEachHandType})
      : resultEachHandType = resultEachHandType ??
            {
              HandType.high: SimulationResultEachHandType(),
              HandType.aPair: SimulationResultEachHandType(),
              HandType.twoPairs: SimulationResultEachHandType(),
              HandType.threeOfAKind: SimulationResultEachHandType(),
              HandType.straight: SimulationResultEachHandType(),
              HandType.flush: SimulationResultEachHandType(),
              HandType.fullhouse: SimulationResultEachHandType(),
              HandType.fourOfAKind: SimulationResultEachHandType(),
              HandType.straightFlush: SimulationResultEachHandType(),
            };

  final Map<HandType, SimulationResultEachHandType> resultEachHandType;

  int get gameCount => resultEachHandType.values
      .fold(0, (total, res) => total + res.win + res.lose + res.even);

  double get winRate =>
      resultEachHandType.values.fold(0, (win, res) => win + res.win) /
      resultEachHandType.values
          .fold(0, (total, res) => total + res.win + res.lose + res.even);

  double get loseRate =>
      resultEachHandType.values.fold(0, (lose, res) => lose + res.lose) /
      resultEachHandType.values
          .fold(0, (total, res) => total + res.win + res.lose + res.even);

  double get evenRate =>
      resultEachHandType.values.fold(0, (even, res) => even + res.even) /
      resultEachHandType.values
          .fold(0, (total, res) => total + res.win + res.lose + res.even);

  SimulationResult copyWithSum(SimulationResult other) {
    final resultEachHandType = {
      HandType.high: SimulationResultEachHandType(),
      HandType.aPair: SimulationResultEachHandType(),
      HandType.twoPairs: SimulationResultEachHandType(),
      HandType.threeOfAKind: SimulationResultEachHandType(),
      HandType.straight: SimulationResultEachHandType(),
      HandType.flush: SimulationResultEachHandType(),
      HandType.fullhouse: SimulationResultEachHandType(),
      HandType.fourOfAKind: SimulationResultEachHandType(),
      HandType.straightFlush: SimulationResultEachHandType(),
    };

    for (final entry in this.resultEachHandType.entries) {
      resultEachHandType[entry.key] = resultEachHandType[entry.key].copyWithSum(
        win: entry.value.win,
        lose: entry.value.lose,
        even: entry.value.even,
      );
    }

    for (final entry in other.resultEachHandType.entries) {
      resultEachHandType[entry.key] = resultEachHandType[entry.key].copyWithSum(
        win: entry.value.win,
        lose: entry.value.lose,
        even: entry.value.even,
      );
    }

    return SimulationResult(resultEachHandType: resultEachHandType);
  }
}

@immutable
class SimulationResultEachHandType {
  SimulationResultEachHandType({int win, int lose, int even})
      : win = win ?? 0,
        lose = lose ?? 0,
        even = even ?? 0;

  final int win;
  final int lose;
  final int even;

  SimulationResultEachHandType copyWithSum({int win, int lose, int even}) =>
      SimulationResultEachHandType(
        win: this.win + win,
        lose: this.lose + lose,
        even: this.even + even,
      );
}

@immutable
class _MutableSimulationResult {
  _MutableSimulationResult(
      {Map<HandType, _MutableSimulationResultEachHandType> resultEachHandType})
      : resultEachHandType = resultEachHandType ??
            {
              HandType.high: _MutableSimulationResultEachHandType(),
              HandType.aPair: _MutableSimulationResultEachHandType(),
              HandType.twoPairs: _MutableSimulationResultEachHandType(),
              HandType.threeOfAKind: _MutableSimulationResultEachHandType(),
              HandType.straight: _MutableSimulationResultEachHandType(),
              HandType.flush: _MutableSimulationResultEachHandType(),
              HandType.fullhouse: _MutableSimulationResultEachHandType(),
              HandType.fourOfAKind: _MutableSimulationResultEachHandType(),
              HandType.straightFlush: _MutableSimulationResultEachHandType(),
            };

  final Map<HandType, _MutableSimulationResultEachHandType> resultEachHandType;

  SimulationResult toImmutable() => SimulationResult(
      resultEachHandType: resultEachHandType
          .map((handType, result) => MapEntry(handType, result.toImmutable())));
}

class _MutableSimulationResultEachHandType {
  _MutableSimulationResultEachHandType({int win, int lose, int even})
      : win = win ?? 0,
        lose = lose ?? 0,
        even = even ?? 0;

  int win;
  int lose;
  int even;

  SimulationResultEachHandType toImmutable() =>
      SimulationResultEachHandType(win: win, lose: lose, even: even);
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
        List.generate(_holeCardsEachPlayer.length, (i) => i)..shuffle();

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
