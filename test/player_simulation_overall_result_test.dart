import 'package:aqua/src/services/simulation_isolate_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("PlayerSimulationOverallResult#equity is valid", () {
    final overall = PlayerSimulationOverallResult();

    overall.wins = 18;
    overall.ties = 18;
    overall.tiesWith[2] = 2;
    overall.tiesWith[3] = 2;
    overall.tiesWith[4] = 2;
    overall.tiesWith[5] = 2;
    overall.tiesWith[6] = 2;
    overall.tiesWith[7] = 2;
    overall.tiesWith[8] = 2;
    overall.tiesWith[9] = 2;
    overall.tiesWith[10] = 2;

    expect(
      overall.equity,
      closeTo(
          (18 +
                  2 / 2 +
                  2 / 3 +
                  2 / 4 +
                  2 / 5 +
                  2 / 6 +
                  2 / 7 +
                  2 / 8 +
                  2 / 9 +
                  2 / 10) /
              36,
          0.0001),
    );
  });
}
