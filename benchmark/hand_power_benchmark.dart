import 'package:aqua/models/deck.dart';
import 'package:aqua/models/hand.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

class HandPowerBenchmark extends BenchmarkBase {
  HandPowerBenchmark() : super('Calculating power of a hand');

  Hand _hand;

  @override
  void run() {
    _hand.power;
  }

  @override
  void setup() {
    final deck = Deck()..shuffle();

    _hand = Hand.bestFrom({
      deck.removeLast(),
      deck.removeLast(),
      deck.removeLast(),
      deck.removeLast(),
      deck.removeLast(),
      deck.removeLast(),
      deck.removeLast(),
    });
  }
}
