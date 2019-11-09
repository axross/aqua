import 'package:aqua/models/card.dart';
import 'package:aqua/models/card_pair.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';
import 'package:meta/meta.dart';

@immutable
class HandRangePart {
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

  Set<CardPair> get combinations => isSuited
      ? _getAllSuitedCardPairsByRank(high, kicker)
      : _getAllOfsuitCardPairsByRank(high, kicker);

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
