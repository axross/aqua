import "package:aqua/src/models/hand_range_preset.dart";
import "package:poker/poker.dart";

final bundledPresets = [
  HandRangePreset(
    name: "Open at UTG",
    handRange: HandRange({
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.ace),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.king),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.jack, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.ten, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.nine, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.eight, kicker: Rank.eight),
      RankPair.ofsuit(high: Rank.seven, kicker: Rank.seven),
      RankPair.ofsuit(high: Rank.six, kicker: Rank.six),
      RankPair.ofsuit(high: Rank.five, kicker: Rank.five),
      RankPair.suited(high: Rank.ace, kicker: Rank.king),
      RankPair.suited(high: Rank.ace, kicker: Rank.queen),
      RankPair.suited(high: Rank.ace, kicker: Rank.jack),
      RankPair.suited(high: Rank.ace, kicker: Rank.ten),
      RankPair.suited(high: Rank.ace, kicker: Rank.nine),
      RankPair.suited(high: Rank.ace, kicker: Rank.eight),
      RankPair.suited(high: Rank.ace, kicker: Rank.five),
      RankPair.suited(high: Rank.ace, kicker: Rank.four),
      RankPair.suited(high: Rank.ace, kicker: Rank.trey),
      RankPair.suited(high: Rank.ace, kicker: Rank.deuce),
      RankPair.suited(high: Rank.king, kicker: Rank.queen),
      RankPair.suited(high: Rank.king, kicker: Rank.jack),
      RankPair.suited(high: Rank.king, kicker: Rank.ten),
      RankPair.suited(high: Rank.king, kicker: Rank.nine),
      RankPair.suited(high: Rank.queen, kicker: Rank.jack),
      RankPair.suited(high: Rank.queen, kicker: Rank.ten),
      RankPair.suited(high: Rank.jack, kicker: Rank.ten),
      RankPair.suited(high: Rank.jack, kicker: Rank.nine),
      RankPair.suited(high: Rank.ten, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.king),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.jack),
    }),
  ),
  HandRangePreset(
    name: "Open at MP",
    handRange: HandRange({
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.ace),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.king),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.jack, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.ten, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.nine, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.eight, kicker: Rank.eight),
      RankPair.ofsuit(high: Rank.seven, kicker: Rank.seven),
      RankPair.ofsuit(high: Rank.six, kicker: Rank.six),
      RankPair.ofsuit(high: Rank.five, kicker: Rank.five),
      RankPair.ofsuit(high: Rank.four, kicker: Rank.four),
      RankPair.suited(high: Rank.ace, kicker: Rank.king),
      RankPair.suited(high: Rank.ace, kicker: Rank.queen),
      RankPair.suited(high: Rank.ace, kicker: Rank.jack),
      RankPair.suited(high: Rank.ace, kicker: Rank.ten),
      RankPair.suited(high: Rank.ace, kicker: Rank.nine),
      RankPair.suited(high: Rank.ace, kicker: Rank.eight),
      RankPair.suited(high: Rank.ace, kicker: Rank.seven),
      RankPair.suited(high: Rank.ace, kicker: Rank.six),
      RankPair.suited(high: Rank.ace, kicker: Rank.five),
      RankPair.suited(high: Rank.ace, kicker: Rank.four),
      RankPair.suited(high: Rank.ace, kicker: Rank.trey),
      RankPair.suited(high: Rank.ace, kicker: Rank.deuce),
      RankPair.suited(high: Rank.king, kicker: Rank.queen),
      RankPair.suited(high: Rank.king, kicker: Rank.jack),
      RankPair.suited(high: Rank.king, kicker: Rank.ten),
      RankPair.suited(high: Rank.king, kicker: Rank.nine),
      RankPair.suited(high: Rank.queen, kicker: Rank.jack),
      RankPair.suited(high: Rank.queen, kicker: Rank.ten),
      RankPair.suited(high: Rank.queen, kicker: Rank.nine),
      RankPair.suited(high: Rank.jack, kicker: Rank.ten),
      RankPair.suited(high: Rank.jack, kicker: Rank.nine),
      RankPair.suited(high: Rank.ten, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.king),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.jack),
    }),
  ),
  HandRangePreset(
    name: "Open at BTN",
    handRange: HandRange({
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.ace),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.king),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.jack, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.ten, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.nine, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.eight, kicker: Rank.eight),
      RankPair.ofsuit(high: Rank.seven, kicker: Rank.seven),
      RankPair.ofsuit(high: Rank.six, kicker: Rank.six),
      RankPair.ofsuit(high: Rank.five, kicker: Rank.five),
      RankPair.suited(high: Rank.ace, kicker: Rank.king),
      RankPair.suited(high: Rank.ace, kicker: Rank.queen),
      RankPair.suited(high: Rank.ace, kicker: Rank.jack),
      RankPair.suited(high: Rank.ace, kicker: Rank.ten),
      RankPair.suited(high: Rank.ace, kicker: Rank.nine),
      RankPair.suited(high: Rank.ace, kicker: Rank.eight),
      RankPair.suited(high: Rank.ace, kicker: Rank.seven),
      RankPair.suited(high: Rank.ace, kicker: Rank.six),
      RankPair.suited(high: Rank.ace, kicker: Rank.five),
      RankPair.suited(high: Rank.ace, kicker: Rank.four),
      RankPair.suited(high: Rank.ace, kicker: Rank.trey),
      RankPair.suited(high: Rank.ace, kicker: Rank.deuce),
      RankPair.suited(high: Rank.king, kicker: Rank.queen),
      RankPair.suited(high: Rank.king, kicker: Rank.jack),
      RankPair.suited(high: Rank.king, kicker: Rank.ten),
      RankPair.suited(high: Rank.king, kicker: Rank.nine),
      RankPair.suited(high: Rank.king, kicker: Rank.eight),
      RankPair.suited(high: Rank.king, kicker: Rank.seven),
      RankPair.suited(high: Rank.king, kicker: Rank.six),
      RankPair.suited(high: Rank.king, kicker: Rank.five),
      RankPair.suited(high: Rank.king, kicker: Rank.four),
      RankPair.suited(high: Rank.king, kicker: Rank.trey),
      RankPair.suited(high: Rank.king, kicker: Rank.deuce),
      RankPair.suited(high: Rank.queen, kicker: Rank.jack),
      RankPair.suited(high: Rank.queen, kicker: Rank.ten),
      RankPair.suited(high: Rank.queen, kicker: Rank.nine),
      RankPair.suited(high: Rank.queen, kicker: Rank.eight),
      RankPair.suited(high: Rank.queen, kicker: Rank.seven),
      RankPair.suited(high: Rank.queen, kicker: Rank.six),
      RankPair.suited(high: Rank.queen, kicker: Rank.five),
      RankPair.suited(high: Rank.jack, kicker: Rank.ten),
      RankPair.suited(high: Rank.jack, kicker: Rank.nine),
      RankPair.suited(high: Rank.jack, kicker: Rank.eight),
      RankPair.suited(high: Rank.jack, kicker: Rank.seven),
      RankPair.suited(high: Rank.ten, kicker: Rank.nine),
      RankPair.suited(high: Rank.ten, kicker: Rank.eight),
      RankPair.suited(high: Rank.ten, kicker: Rank.seven),
      RankPair.suited(high: Rank.nine, kicker: Rank.eight),
      RankPair.suited(high: Rank.nine, kicker: Rank.seven),
      RankPair.suited(high: Rank.nine, kicker: Rank.six),
      RankPair.suited(high: Rank.eight, kicker: Rank.seven),
      RankPair.suited(high: Rank.eight, kicker: Rank.six),
      RankPair.suited(high: Rank.eight, kicker: Rank.five),
      RankPair.suited(high: Rank.seven, kicker: Rank.six),
      RankPair.suited(high: Rank.seven, kicker: Rank.five),
      RankPair.suited(high: Rank.six, kicker: Rank.five),
      RankPair.suited(high: Rank.six, kicker: Rank.four),
      RankPair.suited(high: Rank.five, kicker: Rank.four),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.king),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.eight),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.seven),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.six),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.five),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.four),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.jack, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.jack, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.jack, kicker: Rank.ten),
    }),
  ),
  HandRangePreset(
    name: "Open at SB",
    handRange: HandRange({
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.ace),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.king),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.jack, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.ten, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.nine, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.eight, kicker: Rank.eight),
      RankPair.ofsuit(high: Rank.seven, kicker: Rank.seven),
      RankPair.ofsuit(high: Rank.six, kicker: Rank.six),
      RankPair.ofsuit(high: Rank.five, kicker: Rank.five),
      RankPair.suited(high: Rank.ace, kicker: Rank.king),
      RankPair.suited(high: Rank.ace, kicker: Rank.queen),
      RankPair.suited(high: Rank.ace, kicker: Rank.jack),
      RankPair.suited(high: Rank.ace, kicker: Rank.ten),
      RankPair.suited(high: Rank.ace, kicker: Rank.nine),
      RankPair.suited(high: Rank.ace, kicker: Rank.eight),
      RankPair.suited(high: Rank.ace, kicker: Rank.seven),
      RankPair.suited(high: Rank.ace, kicker: Rank.six),
      RankPair.suited(high: Rank.ace, kicker: Rank.five),
      RankPair.suited(high: Rank.ace, kicker: Rank.four),
      RankPair.suited(high: Rank.ace, kicker: Rank.trey),
      RankPair.suited(high: Rank.king, kicker: Rank.queen),
      RankPair.suited(high: Rank.king, kicker: Rank.jack),
      RankPair.suited(high: Rank.king, kicker: Rank.ten),
      RankPair.suited(high: Rank.king, kicker: Rank.nine),
      RankPair.suited(high: Rank.king, kicker: Rank.eight),
      RankPair.suited(high: Rank.king, kicker: Rank.seven),
      RankPair.suited(high: Rank.king, kicker: Rank.six),
      RankPair.suited(high: Rank.king, kicker: Rank.five),
      RankPair.suited(high: Rank.king, kicker: Rank.four),
      RankPair.suited(high: Rank.queen, kicker: Rank.jack),
      RankPair.suited(high: Rank.queen, kicker: Rank.ten),
      RankPair.suited(high: Rank.queen, kicker: Rank.nine),
      RankPair.suited(high: Rank.queen, kicker: Rank.eight),
      RankPair.suited(high: Rank.queen, kicker: Rank.seven),
      RankPair.suited(high: Rank.jack, kicker: Rank.ten),
      RankPair.suited(high: Rank.jack, kicker: Rank.nine),
      RankPair.suited(high: Rank.ten, kicker: Rank.nine),
      RankPair.suited(high: Rank.nine, kicker: Rank.eight),
      RankPair.suited(high: Rank.nine, kicker: Rank.seven),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.king),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.eight),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.seven),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.six),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.five),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.four),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.trey),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.deuce),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.eight),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.seven),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.six),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.five),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.four),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.jack, kicker: Rank.ten),
    }),
  ),
  HandRangePreset(
    name: "Call/3-bet to UTG",
    handRange: HandRange({
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.ace),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.king),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.jack, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.ten, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.nine, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.eight, kicker: Rank.eight),
      RankPair.suited(high: Rank.ace, kicker: Rank.king),
      RankPair.suited(high: Rank.ace, kicker: Rank.queen),
      RankPair.suited(high: Rank.ace, kicker: Rank.jack),
      RankPair.suited(high: Rank.ace, kicker: Rank.ten),
      RankPair.suited(high: Rank.ace, kicker: Rank.five),
      RankPair.suited(high: Rank.ace, kicker: Rank.four),
      RankPair.suited(high: Rank.ace, kicker: Rank.trey),
      RankPair.suited(high: Rank.ace, kicker: Rank.deuce),
      RankPair.suited(high: Rank.king, kicker: Rank.queen),
      RankPair.suited(high: Rank.king, kicker: Rank.jack),
      RankPair.suited(high: Rank.seven, kicker: Rank.six),
      RankPair.suited(high: Rank.six, kicker: Rank.five),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.king),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.queen),
    }),
  ),
  HandRangePreset(
    name: "Call/3-bet to BTN",
    handRange: HandRange({
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.ace),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.king),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.jack, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.ten, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.nine, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.eight, kicker: Rank.eight),
      RankPair.ofsuit(high: Rank.seven, kicker: Rank.seven),
      RankPair.ofsuit(high: Rank.six, kicker: Rank.six),
      RankPair.ofsuit(high: Rank.five, kicker: Rank.five),
      RankPair.suited(high: Rank.ace, kicker: Rank.king),
      RankPair.suited(high: Rank.ace, kicker: Rank.queen),
      RankPair.suited(high: Rank.ace, kicker: Rank.jack),
      RankPair.suited(high: Rank.ace, kicker: Rank.ten),
      RankPair.suited(high: Rank.ace, kicker: Rank.nine),
      RankPair.suited(high: Rank.ace, kicker: Rank.eight),
      RankPair.suited(high: Rank.ace, kicker: Rank.seven),
      RankPair.suited(high: Rank.ace, kicker: Rank.six),
      RankPair.suited(high: Rank.ace, kicker: Rank.five),
      RankPair.suited(high: Rank.ace, kicker: Rank.four),
      RankPair.suited(high: Rank.ace, kicker: Rank.trey),
      RankPair.suited(high: Rank.ace, kicker: Rank.deuce),
      RankPair.suited(high: Rank.king, kicker: Rank.queen),
      RankPair.suited(high: Rank.king, kicker: Rank.jack),
      RankPair.suited(high: Rank.king, kicker: Rank.ten),
      RankPair.suited(high: Rank.queen, kicker: Rank.jack),
      RankPair.suited(high: Rank.jack, kicker: Rank.ten),
      RankPair.suited(high: Rank.ten, kicker: Rank.nine),
      RankPair.suited(high: Rank.nine, kicker: Rank.eight),
      RankPair.suited(high: Rank.eight, kicker: Rank.seven),
      RankPair.suited(high: Rank.seven, kicker: Rank.six),
      RankPair.suited(high: Rank.six, kicker: Rank.five),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.king),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.nine),
      RankPair.ofsuit(high: Rank.ace, kicker: Rank.eight),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.queen),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.king, kicker: Rank.ten),
      RankPair.ofsuit(high: Rank.queen, kicker: Rank.jack),
      RankPair.ofsuit(high: Rank.jack, kicker: Rank.ten),
    }),
  ),
];
