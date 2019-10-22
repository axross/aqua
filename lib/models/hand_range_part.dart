import 'package:meta/meta.dart' show immutable;
import './card.dart' show Card, Rank, Suit;
import './card_pair.dart' show CardPair;

@immutable
class HandRangePart {
  final Rank high;
  final Rank kicker;
  final bool isSuited;

  const HandRangePart({this.high, this.kicker, this.isSuited})
      : assert(high != null),
        assert(kicker != null),
        assert(isSuited != null);

  HandRangePart.fromJson(Map<String, dynamic> json)
      : high = json['high'],
        kicker = json['kicker'],
        isSuited = json['isSuited'];

  Set<CardPair> get combinations => isSuited
      ? _getAllSuitedCardPairsByRank(high, kicker)
      : _getAllOfsuitCardPairsByRank(high, kicker);

  Map<String, dynamic> toJson() => {
        'high': high,
        'kicker': kicker,
        'isSuited': isSuited,
      };

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
      }
    };
