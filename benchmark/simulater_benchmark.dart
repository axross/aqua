import 'package:aqua/parser.dart' show parseRangeString;
import 'package:aqua/simulator.dart' show Simulator;

void main() {
  print('10x10000');

  final ranges = [
    'A2s+K7s+Q8s+J8s+97s+87s76s65sA2+KT+QT+JT22+',
    'AKsAKTT+',
    'A8s+KTs+QTs+JTsT9sAT+KJ+66+',
  ];
  final holeCardsEachPlayer =
      ranges.map((range) => parseRangeString(range)).toList();

  print(
      'hands: ${holeCardsEachPlayer.map((pairs) => pairs.length).toList()} patterns');

  int elapsed = 0;

  for (int i = 0; i < 10; ++i) {
    print('start: $i');

    final startedAt = DateTime.now();

    final simulator = Simulator();

    final results = simulator.simulate(holeCardsEachPlayer, times: 100000);

    final endedAt = DateTime.now();

    elapsed += endedAt.difference(startedAt).inMilliseconds;

    for (int i = 0; i < results.length; ++i) {
      print('Player ${ranges[i]}');

      int won = 0;

      for (final entry in results.elementAt(i).entries) {
        print(
            '  ${entry.key}: ${entry.value.won} won, ${entry.value.lost} lost and ${entry.value.even} even');

        won += entry.value.won;
      }

      print('  ${(won * 100 / 100000).toStringAsFixed(2)}% won');
    }
    print('end: $i');
  }

  print('${elapsed / 10}ms in an average');
}
