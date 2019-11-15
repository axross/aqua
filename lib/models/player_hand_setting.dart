import 'package:aqua/models/card.dart';
import 'package:aqua/models/card_pair.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';
import 'package:meta/meta.dart';

@immutable
class PlayerHandSetting {
  const PlayerHandSetting({@required this.parts}) : assert(parts != null);

  PlayerHandSetting.fromHoleCards({
    @required Card left,
    @required Card right,
  }) : parts = {HoleCards(left: left, right: right)};

  PlayerHandSetting.emptyHoleCards() : parts = {HoleCards()};

  PlayerHandSetting.emptyHandRange() : parts = {};

  final Set<PlayerHandSettingRangePart> parts;

  PlayerHandSettingType get type {
    if (parts.length == 1 && parts.first is HoleCards) {
      return PlayerHandSettingType.holeCards;
    }

    if (parts.every((part) => part is HandRangePart)) {
      return PlayerHandSettingType.handRange;
    }

    throw AssertionError("unreachable here.");
  }

  HoleCards get onlyHoleCards {
    assert(type == PlayerHandSettingType.holeCards);

    return parts.first;
  }

  Set<HandRangePart> get onlyHandRange {
    assert(type == PlayerHandSettingType.handRange);

    return Set<HandRangePart>.from(parts);
  }

  Set<CardPair> get cardPairCombinations => parts.fold<List<CardPair>>(
        <CardPair>[],
        (list, part) => list..addAll(part.cardPairCombinations),
      ).toSet();
}

enum PlayerHandSettingType {
  holeCards,
  handRange,
}

abstract class PlayerHandSettingRangePart {
  Set<CardPair> get cardPairCombinations;
}

@immutable
class HoleCards implements PlayerHandSettingRangePart {
  HoleCards({this.left, this.right});

  final Card left;
  final Card right;

  @override
  Set<CardPair> get cardPairCombinations =>
      left != null && right != null ? {CardPair(left, right)} : {};

  @override
  int get hashCode => left.hashCode * 17 + right.hashCode;

  @override
  bool operator ==(Object other) =>
      other is HoleCards && other.left == left && other.right == right;
}

@immutable
class HandRangePart implements PlayerHandSettingRangePart {
  const HandRangePart({
    @required this.high,
    @required this.kicker,
    bool isSuited,
  })  : assert(high != null),
        assert(kicker != null),
        isSuited = isSuited ?? false;

  final Rank high;
  final Rank kicker;
  final bool isSuited;

  bool get isPocket => high == kicker;

  @override
  Set<CardPair> get cardPairCombinations => isSuited
      ? _getAllSuitedCardPairsByRank(high, kicker)
      : _getAllOfsuitCardPairsByRank(high, kicker);

  @override
  String toString() => "HandRangePart<$high, $kicker, isSuited: $isSuited>";

  @override
  int get hashCode =>
      high.hashCode * 17 * 17 + kicker.hashCode * 17 + isSuited.hashCode;

  @override
  bool operator ==(Object other) =>
      other is HandRangePart &&
      other.high == high &&
      other.kicker == kicker &&
      other.isSuited == isSuited;
}

Set<CardPair> _getAllSuitedCardPairsByRank(Rank rankA, Rank rankB) => {
      CardPair(
        Card(rank: rankA, suit: Suit.spade),
        Card(rank: rankB, suit: Suit.spade),
      ),
      CardPair(
        Card(rank: rankA, suit: Suit.heart),
        Card(rank: rankB, suit: Suit.heart),
      ),
      CardPair(
        Card(rank: rankA, suit: Suit.diamond),
        Card(rank: rankB, suit: Suit.diamond),
      ),
      CardPair(
        Card(rank: rankA, suit: Suit.club),
        Card(rank: rankB, suit: Suit.club),
      ),
    };

Set<CardPair> _getAllOfsuitCardPairsByRank(Rank rankA, Rank rankB) => {
      CardPair(
        Card(rank: rankA, suit: Suit.spade),
        Card(rank: rankB, suit: Suit.heart),
      ),
      CardPair(
        Card(rank: rankA, suit: Suit.spade),
        Card(rank: rankB, suit: Suit.diamond),
      ),
      CardPair(
        Card(rank: rankA, suit: Suit.spade),
        Card(rank: rankB, suit: Suit.club),
      ),
      CardPair(
        Card(rank: rankA, suit: Suit.heart),
        Card(rank: rankB, suit: Suit.diamond),
      ),
      CardPair(
        Card(rank: rankA, suit: Suit.heart),
        Card(rank: rankB, suit: Suit.club),
      ),
      CardPair(
        Card(rank: rankA, suit: Suit.diamond),
        Card(rank: rankB, suit: Suit.club),
      ),
      if (rankA != rankB) ...{
        CardPair(
          Card(rank: rankA, suit: Suit.heart),
          Card(rank: rankB, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: rankA, suit: Suit.diamond),
          Card(rank: rankB, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: rankA, suit: Suit.diamond),
          Card(rank: rankB, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: rankA, suit: Suit.club),
          Card(rank: rankB, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: rankA, suit: Suit.club),
          Card(rank: rankB, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: rankA, suit: Suit.club),
          Card(rank: rankB, suit: Suit.diamond),
        ),
      },
    };

const handRangePartsInStrongnessOrder = [
  HandRangePart(high: Rank.ace, kicker: Rank.ace),
  HandRangePart(high: Rank.king, kicker: Rank.king),
  HandRangePart(high: Rank.queen, kicker: Rank.queen),
  HandRangePart(high: Rank.jack, kicker: Rank.jack),
  HandRangePart(high: Rank.ace, kicker: Rank.king, isSuited: true),
  HandRangePart(high: Rank.ace, kicker: Rank.queen, isSuited: true),
  HandRangePart(high: Rank.ten, kicker: Rank.ten),
  HandRangePart(high: Rank.ace, kicker: Rank.king),
  HandRangePart(high: Rank.ace, kicker: Rank.jack, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.queen, isSuited: true),
  HandRangePart(high: Rank.nine, kicker: Rank.nine),
  HandRangePart(high: Rank.ace, kicker: Rank.ten, isSuited: true),
  HandRangePart(high: Rank.ace, kicker: Rank.queen),
  HandRangePart(high: Rank.king, kicker: Rank.jack, isSuited: true),
  HandRangePart(high: Rank.eight, kicker: Rank.eight),
  HandRangePart(high: Rank.queen, kicker: Rank.jack, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.ten, isSuited: true),
  HandRangePart(high: Rank.ace, kicker: Rank.nine, isSuited: true),
  HandRangePart(high: Rank.ace, kicker: Rank.jack),
  HandRangePart(high: Rank.queen, kicker: Rank.ten, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.queen),
  HandRangePart(high: Rank.seven, kicker: Rank.seven),
  HandRangePart(high: Rank.jack, kicker: Rank.ten, isSuited: true),
  HandRangePart(high: Rank.ace, kicker: Rank.eight, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.nine, isSuited: true),
  HandRangePart(high: Rank.ace, kicker: Rank.ten),
  HandRangePart(high: Rank.ace, kicker: Rank.five, isSuited: true),
  HandRangePart(high: Rank.ace, kicker: Rank.seven, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.jack),
  HandRangePart(high: Rank.six, kicker: Rank.six),
  HandRangePart(high: Rank.ten, kicker: Rank.nine, isSuited: true),
  HandRangePart(high: Rank.ace, kicker: Rank.four, isSuited: true),
  HandRangePart(high: Rank.queen, kicker: Rank.nine, isSuited: true),
  HandRangePart(high: Rank.jack, kicker: Rank.nine, isSuited: true),
  HandRangePart(high: Rank.queen, kicker: Rank.jack),
  HandRangePart(high: Rank.ace, kicker: Rank.six, isSuited: true),
  HandRangePart(high: Rank.five, kicker: Rank.five),
  HandRangePart(high: Rank.ace, kicker: Rank.three, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.eight, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.ten),
  HandRangePart(high: Rank.nine, kicker: Rank.eight, isSuited: true),
  HandRangePart(high: Rank.ten, kicker: Rank.eight, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.seven, isSuited: true),
  HandRangePart(high: Rank.ace, kicker: Rank.two, isSuited: true),
  HandRangePart(high: Rank.eight, kicker: Rank.seven, isSuited: true),
  HandRangePart(high: Rank.queen, kicker: Rank.ten),
  HandRangePart(high: Rank.queen, kicker: Rank.eight, isSuited: true),
  HandRangePart(high: Rank.four, kicker: Rank.four),
  HandRangePart(high: Rank.ace, kicker: Rank.nine),
  HandRangePart(high: Rank.jack, kicker: Rank.eight, isSuited: true),
  HandRangePart(high: Rank.seven, kicker: Rank.six, isSuited: true),
  HandRangePart(high: Rank.jack, kicker: Rank.ten),
  HandRangePart(high: Rank.nine, kicker: Rank.seven, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.six, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.five, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.four, isSuited: true),
  HandRangePart(high: Rank.ten, kicker: Rank.seven, isSuited: true),
  HandRangePart(high: Rank.queen, kicker: Rank.seven, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.nine),
  HandRangePart(high: Rank.six, kicker: Rank.five, isSuited: true),
  HandRangePart(high: Rank.ten, kicker: Rank.nine),
  HandRangePart(high: Rank.eight, kicker: Rank.six, isSuited: true),
  HandRangePart(high: Rank.ace, kicker: Rank.eight),
  HandRangePart(high: Rank.jack, kicker: Rank.seven, isSuited: true),
  HandRangePart(high: Rank.three, kicker: Rank.three),
  HandRangePart(high: Rank.five, kicker: Rank.four, isSuited: true),
  HandRangePart(high: Rank.queen, kicker: Rank.six, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.three, isSuited: true),
  HandRangePart(high: Rank.queen, kicker: Rank.nine),
  HandRangePart(high: Rank.seven, kicker: Rank.five, isSuited: true),
  HandRangePart(high: Rank.two, kicker: Rank.two),
  HandRangePart(high: Rank.jack, kicker: Rank.nine),
  HandRangePart(high: Rank.six, kicker: Rank.four, isSuited: true),
  HandRangePart(high: Rank.queen, kicker: Rank.five, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.two, isSuited: true),
  HandRangePart(high: Rank.nine, kicker: Rank.six, isSuited: true),
  HandRangePart(high: Rank.queen, kicker: Rank.three, isSuited: true),
  HandRangePart(high: Rank.jack, kicker: Rank.eight),
  HandRangePart(high: Rank.nine, kicker: Rank.eight),
  HandRangePart(high: Rank.ten, kicker: Rank.eight),
  HandRangePart(high: Rank.nine, kicker: Rank.seven),
  HandRangePart(high: Rank.ace, kicker: Rank.seven),
  HandRangePart(high: Rank.ten, kicker: Rank.seven),
  HandRangePart(high: Rank.queen, kicker: Rank.four, isSuited: true),
  HandRangePart(high: Rank.queen, kicker: Rank.eight),
  HandRangePart(high: Rank.jack, kicker: Rank.five, isSuited: true),
  HandRangePart(high: Rank.ten, kicker: Rank.six),
  HandRangePart(high: Rank.seven, kicker: Rank.five),
  HandRangePart(high: Rank.jack, kicker: Rank.four, isSuited: true),
  HandRangePart(high: Rank.seven, kicker: Rank.four, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.eight),
  HandRangePart(high: Rank.eight, kicker: Rank.six),
  HandRangePart(high: Rank.five, kicker: Rank.three, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.seven),
  HandRangePart(high: Rank.six, kicker: Rank.three, isSuited: true),
  HandRangePart(high: Rank.jack, kicker: Rank.six, isSuited: true),
  HandRangePart(high: Rank.eight, kicker: Rank.five),
  HandRangePart(high: Rank.ten, kicker: Rank.six, isSuited: true),
  HandRangePart(high: Rank.seven, kicker: Rank.six),
  HandRangePart(high: Rank.ace, kicker: Rank.six),
  HandRangePart(high: Rank.ten, kicker: Rank.two),
  HandRangePart(high: Rank.nine, kicker: Rank.five, isSuited: true),
  HandRangePart(high: Rank.eight, kicker: Rank.four),
  HandRangePart(high: Rank.six, kicker: Rank.two),
  HandRangePart(high: Rank.ten, kicker: Rank.five, isSuited: true),
  HandRangePart(high: Rank.nine, kicker: Rank.five),
  HandRangePart(high: Rank.ace, kicker: Rank.five),
  HandRangePart(high: Rank.queen, kicker: Rank.seven),
  HandRangePart(high: Rank.ten, kicker: Rank.five),
  HandRangePart(high: Rank.eight, kicker: Rank.seven),
  HandRangePart(high: Rank.eight, kicker: Rank.three),
  HandRangePart(high: Rank.six, kicker: Rank.five),
  HandRangePart(high: Rank.queen, kicker: Rank.two, isSuited: true),
  HandRangePart(high: Rank.nine, kicker: Rank.four),
  HandRangePart(high: Rank.seven, kicker: Rank.four),
  HandRangePart(high: Rank.five, kicker: Rank.four),
  HandRangePart(high: Rank.ace, kicker: Rank.four),
  HandRangePart(high: Rank.ten, kicker: Rank.four),
  HandRangePart(high: Rank.eight, kicker: Rank.two),
  HandRangePart(high: Rank.six, kicker: Rank.four),
  HandRangePart(high: Rank.four, kicker: Rank.two),
  HandRangePart(high: Rank.jack, kicker: Rank.seven),
  HandRangePart(high: Rank.nine, kicker: Rank.three),
  HandRangePart(high: Rank.eight, kicker: Rank.five, isSuited: true),
  HandRangePart(high: Rank.seven, kicker: Rank.three),
  HandRangePart(high: Rank.five, kicker: Rank.three),
  HandRangePart(high: Rank.ten, kicker: Rank.three),
  HandRangePart(high: Rank.six, kicker: Rank.three),
  HandRangePart(high: Rank.king, kicker: Rank.six),
  HandRangePart(high: Rank.jack, kicker: Rank.six),
  HandRangePart(high: Rank.nine, kicker: Rank.six),
  HandRangePart(high: Rank.nine, kicker: Rank.two),
  HandRangePart(high: Rank.seven, kicker: Rank.two),
  HandRangePart(high: Rank.five, kicker: Rank.two),
  HandRangePart(high: Rank.queen, kicker: Rank.four),
  HandRangePart(high: Rank.king, kicker: Rank.five),
  HandRangePart(high: Rank.jack, kicker: Rank.five),
  HandRangePart(high: Rank.four, kicker: Rank.three, isSuited: true),
  HandRangePart(high: Rank.queen, kicker: Rank.three),
  HandRangePart(high: Rank.four, kicker: Rank.three),
  HandRangePart(high: Rank.king, kicker: Rank.four),
  HandRangePart(high: Rank.jack, kicker: Rank.four),
  HandRangePart(high: Rank.ten, kicker: Rank.four, isSuited: true),
  HandRangePart(high: Rank.queen, kicker: Rank.six),
  HandRangePart(high: Rank.queen, kicker: Rank.two),
  HandRangePart(high: Rank.jack, kicker: Rank.three, isSuited: true),
  HandRangePart(high: Rank.jack, kicker: Rank.three),
  HandRangePart(high: Rank.ten, kicker: Rank.three, isSuited: true),
  HandRangePart(high: Rank.ace, kicker: Rank.three),
  HandRangePart(high: Rank.queen, kicker: Rank.five),
  HandRangePart(high: Rank.jack, kicker: Rank.two),
  HandRangePart(high: Rank.eight, kicker: Rank.four, isSuited: true),
  HandRangePart(high: Rank.eight, kicker: Rank.two, isSuited: true),
  HandRangePart(high: Rank.four, kicker: Rank.two, isSuited: true),
  HandRangePart(high: Rank.nine, kicker: Rank.three, isSuited: true),
  HandRangePart(high: Rank.seven, kicker: Rank.three, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.three),
  HandRangePart(high: Rank.jack, kicker: Rank.two, isSuited: true),
  HandRangePart(high: Rank.nine, kicker: Rank.two, isSuited: true),
  HandRangePart(high: Rank.five, kicker: Rank.two, isSuited: true),
  HandRangePart(high: Rank.king, kicker: Rank.two),
  HandRangePart(high: Rank.ten, kicker: Rank.two, isSuited: true),
  HandRangePart(high: Rank.six, kicker: Rank.two, isSuited: true),
  HandRangePart(high: Rank.three, kicker: Rank.two),
  HandRangePart(high: Rank.ace, kicker: Rank.two),
  HandRangePart(high: Rank.eight, kicker: Rank.three, isSuited: true),
  HandRangePart(high: Rank.nine, kicker: Rank.four, isSuited: true),
  HandRangePart(high: Rank.seven, kicker: Rank.two, isSuited: true),
  HandRangePart(high: Rank.three, kicker: Rank.two, isSuited: true),
];
