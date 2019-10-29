import 'package:aqua/models/hand_range_part.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/simulator.dart';

void main() {
  final playerHandSettings = [
    PlayerHandRange({
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
    PlayerHandRange({
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
    PlayerHandRange({
      HandRangePart(high: Rank.eight, kicker: Rank.seven, isSuited: true),
      HandRangePart(high: Rank.nine, kicker: Rank.eight, isSuited: true),
      HandRangePart(high: Rank.seven, kicker: Rank.six, isSuited: true),
      HandRangePart(high: Rank.ten, kicker: Rank.ten),
      HandRangePart(high: Rank.jack, kicker: Rank.jack),
      HandRangePart(high: Rank.queen, kicker: Rank.queen),
      HandRangePart(high: Rank.king, kicker: Rank.king),
      HandRangePart(high: Rank.ace, kicker: Rank.ace),
    }),
    PlayerHandRange({
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

  int elapsed = 0;

  for (int i = 0; i < 10; ++i) {
    print('start: $i');

    final startedAt = DateTime.now();

    final simulator = Simulator(
      playerHandSettings: playerHandSettings,
      board: [],
    );

    simulator.simulate(times: 10000);

    final endedAt = DateTime.now();

    elapsed += endedAt.difference(startedAt).inMilliseconds;

    print('end: $i');
  }

  print('${elapsed / 10}ms in an average');
}
