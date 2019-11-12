import 'package:aqua/models/card.dart';
import 'package:aqua/models/card_pair.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';
import 'package:meta/meta.dart';

@immutable
class PlayerHandSetting {
  const PlayerHandSetting({@required this.parts}) : assert(parts != null);

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
