import "dart:math" show Random;
import 'package:meta/meta.dart' show required;
import './card.dart' show Card;
import './card_pair.dart' show CardPair;
import './deck.dart' show Deck;
import './player_hand_setting.dart' show PlayerHandSetting;
import './simulation_result.dart' show SimulationResult;
import './showdown.dart' show Showdown;

class Simulator {
  Simulator({@required this.handSettings, @required Iterable<Card> board})
      : assert(handSettings != null),
        assert(handSettings.length >= 2),
        assert(board != null),
        board = board.where((card) => card != null).toSet() {
    assert(board.length == 0 ||
        board.length == 3 ||
        board.length == 4 ||
        board.length == 5);
  }

  final List<PlayerHandSetting> handSettings;
  final Set<Card> board;

  List<SimulationResult> simulate({int times = 1}) {
    final holeCardsEachPlayer = <Set<CardPair>>[];
    final resultEachPlayer = <SimulationResult>[];

    for (final handSetting in handSettings) {
      holeCardsEachPlayer.add(handSetting.cardPairCombinations);
      resultEachPlayer.add(SimulationResult.empty());
    }

    for (int i = 0; i < times; ++i) {
      final deck = Deck();

      for (final card in board) {
        deck.remove(card);
      }

      final holeCards = _getHoleCardPermutationRandomly(holeCardsEachPlayer);

      for (final holeCard in holeCards) {
        deck.remove(holeCard[0]);
        deck.remove(holeCard[1]);
      }

      deck.shuffle();

      final showdown = Showdown(
        board: board.union(deck.take(5 - board.length).toSet()),
        holeCards: holeCards,
      );
      // final hands = showdown.hands.toList();

      Set<int> wonPlayers = Set<int>();
      int wonPower = 0;

      for (int index = 0; index < showdown.hands.length; ++index) {
        final hand = showdown.hands.elementAt(index);

        if (hand.power > wonPower) {
          wonPlayers = {index};
          wonPower = hand.power;
        } else if (hand.power == wonPower) {
          wonPlayers.add(index);
        }
      }

      for (int index = 0; index < resultEachPlayer.length; ++index) {
        if (wonPlayers.contains(index)) {
          if (wonPlayers.length == 1) {
            resultEachPlayer[index][showdown.hands.elementAt(index).type].win +=
                1;
          } else {
            resultEachPlayer[index][showdown.hands.elementAt(index).type]
                .even += 1;
          }
        } else {
          resultEachPlayer[index][showdown.hands.elementAt(index).type].lose +=
              1;
        }
      }
    }

    return resultEachPlayer;
  }
}

class SimulationCancelException implements Exception {}

class IncompleteHandSettingException implements SimulationCancelException {}

class DuplicatedCardException implements SimulationCancelException {}

class NoPossibleCombinationException implements SimulationCancelException {}

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

  throw NoPossibleCombinationException();
}
