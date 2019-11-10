import 'package:aqua/models/card_pair.dart';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/simulator.dart';

class ChoosingPossibleHandMatchupBenchmark extends BenchmarkBase {
  ChoosingPossibleHandMatchupBenchmark()
      : super('Choosing possible hand match-up');

  List<Set<CardPair>> _holeCardsEachPlayer;

  @override
  void run() {
    getHoleCardPermutationRandomly(_holeCardsEachPlayer, {});
  }

  @override
  void setup() {
    final playerHandSettings = [
      PlayerHandSetting(parts: {
        HandRangePart(high: Rank.ace, kicker: Rank.two, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.three, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.four, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.five, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.six, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.seven, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.eight, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.nine, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.ten, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.jack, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.queen, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.king, isSuited: true),
        HandRangePart(high: Rank.five, kicker: Rank.five),
        HandRangePart(high: Rank.six, kicker: Rank.six),
        HandRangePart(high: Rank.seven, kicker: Rank.seven),
        HandRangePart(high: Rank.eight, kicker: Rank.eight),
        HandRangePart(high: Rank.nine, kicker: Rank.nine),
        HandRangePart(high: Rank.ten, kicker: Rank.ten),
        HandRangePart(high: Rank.jack, kicker: Rank.jack),
        HandRangePart(high: Rank.queen, kicker: Rank.queen),
        HandRangePart(high: Rank.king, kicker: Rank.king),
        HandRangePart(high: Rank.ace, kicker: Rank.ace),
      }),
      PlayerHandSetting(parts: {
        HandRangePart(high: Rank.ace, kicker: Rank.two, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.three, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.four, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.five, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.six, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.seven, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.eight, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.nine, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.ten, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.jack, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.queen, isSuited: true),
        HandRangePart(high: Rank.ace, kicker: Rank.king, isSuited: true),
        HandRangePart(high: Rank.five, kicker: Rank.five),
        HandRangePart(high: Rank.six, kicker: Rank.six),
        HandRangePart(high: Rank.seven, kicker: Rank.seven),
        HandRangePart(high: Rank.eight, kicker: Rank.eight),
        HandRangePart(high: Rank.nine, kicker: Rank.nine),
        HandRangePart(high: Rank.ten, kicker: Rank.ten),
        HandRangePart(high: Rank.jack, kicker: Rank.jack),
        HandRangePart(high: Rank.queen, kicker: Rank.queen),
        HandRangePart(high: Rank.king, kicker: Rank.king),
        HandRangePart(high: Rank.ace, kicker: Rank.ace),
      }),
      PlayerHandSetting(parts: {
        HandRangePart(high: Rank.eight, kicker: Rank.seven, isSuited: true),
        HandRangePart(high: Rank.nine, kicker: Rank.eight, isSuited: true),
        HandRangePart(high: Rank.seven, kicker: Rank.six, isSuited: true),
        HandRangePart(high: Rank.ten, kicker: Rank.ten),
        HandRangePart(high: Rank.jack, kicker: Rank.jack),
        HandRangePart(high: Rank.queen, kicker: Rank.queen),
        HandRangePart(high: Rank.king, kicker: Rank.king),
        HandRangePart(high: Rank.ace, kicker: Rank.ace),
      }),
      PlayerHandSetting(parts: {
        HandRangePart(high: Rank.eight, kicker: Rank.seven, isSuited: true),
        HandRangePart(high: Rank.nine, kicker: Rank.eight, isSuited: true),
        HandRangePart(high: Rank.seven, kicker: Rank.six, isSuited: true),
        HandRangePart(high: Rank.ten, kicker: Rank.ten),
        HandRangePart(high: Rank.jack, kicker: Rank.jack),
        HandRangePart(high: Rank.queen, kicker: Rank.queen),
        HandRangePart(high: Rank.king, kicker: Rank.king),
        HandRangePart(high: Rank.ace, kicker: Rank.ace),
      }),
    ];

    _holeCardsEachPlayer = playerHandSettings
        .map((playerHandSetting) => playerHandSetting.cardPairCombinations)
        .toList();
  }
}
