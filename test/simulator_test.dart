import 'package:aqua/parser.dart' show parseRangeString;
import 'package:aqua/simulator.dart' show Simulator;
import 'package:test/test.dart';

void main() {
  test("Simulator#simulate()", () {
    final simulator = Simulator();
    final results = simulator.simulate({
      parseRangeString("AsKs"),
      parseRangeString("22+"),
      parseRangeString("KJ+"),
    });

    final totalWon = results.fold(
      0,
      (wonOrEven, result) =>
          wonOrEven +
          result.values.fold(
            0,
            (twe, h) => twe + h.won + h.even,
          ),
    );
    final totalLost = results.fold(
      0,
      (lost, result) =>
          lost +
          result.values.fold(
            0,
            (tl, h) => tl + h.lost,
          ),
    );

    expect(
      totalWon,
      greaterThanOrEqualTo(1),
    );
    expect(
      totalWon + totalLost,
      equals(3),
    );
  });
}
