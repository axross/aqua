import 'package:aqua/models/card.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/simulator.dart';
import 'package:aqua/models/suit.dart';
import 'package:test/test.dart';

void main() {
  test("Simulator", () {
    final simulator = Simulator(
      playerHandSettings: [
        PlayerHoleCards(
            left: Card(rank: Rank.ace, suit: Suit.spade),
            right: Card(rank: Rank.king, suit: Suit.spade)),
        PlayerHoleCards(
            left: Card(rank: Rank.king, suit: Suit.spade),
            right: Card(rank: Rank.queen, suit: Suit.spade)),
      ],
      board: [],
    );

    expect(() => simulator.simulate(),
        throwsA(const TypeMatcher<NoPossibleCombinationException>()));
  });

  test("Simulator", () {
    final simulator = Simulator(
      playerHandSettings: [
        PlayerHoleCards(
            left: Card(rank: Rank.ace, suit: Suit.spade),
            right: Card(rank: Rank.king, suit: Suit.spade)),
        PlayerHoleCards(left: Card(rank: Rank.king, suit: Suit.spade)),
      ],
      board: [],
    );

    expect(() => simulator.simulate(),
        throwsA(const TypeMatcher<InsafficientHandSettingException>()));
  });
}
