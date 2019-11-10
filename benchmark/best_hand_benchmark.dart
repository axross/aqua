import 'package:aqua/models/card.dart';
import 'package:aqua/models/deck.dart';
import 'package:aqua/models/hand.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

class BestHandBenchmark extends BenchmarkBase {
  BestHandBenchmark() : super('Choosing the best hand from 7 cards');

  List<Card> _holeCards;

  List<Card> _board;

  @override
  void run() {
    Hand.bestFrom({..._holeCards, ..._board});
  }

  @override
  void setup() {
    final deck = Deck()..shuffle();

    _holeCards = [deck.removeLast(), deck.removeLast()];
    _board = [
      deck.removeLast(),
      deck.removeLast(),
      deck.removeLast(),
      deck.removeLast(),
      deck.removeLast()
    ];
  }
}
