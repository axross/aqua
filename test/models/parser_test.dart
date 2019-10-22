import 'package:aqua/parser.dart' show parseRangeString;
import 'package:test/test.dart';
import '../../lib/models/card.dart' show Card, Rank, Suit;
import '../../lib/models/card_pair.dart' show CardPair;

void main() {
  test('parseRangeString() returns a set of cards by the given string', () {
    expect(
      parseRangeString("AsKs"),
      equals({
        CardPair(
          Card(rank: Rank.ace, suit: Suit.spade),
          Card(rank: Rank.king, suit: Suit.spade),
        ),
      }),
    );
    expect(
      parseRangeString("QdQc"),
      equals({
        CardPair(
            Card(rank: Rank.queen, suit: Suit.diamond),
            Card(
              rank: Rank.queen,
              suit: Suit.club,
            ))
      }),
    );
    expect(
      parseRangeString("ATs+"),
      equals({
        CardPair(
          Card(rank: Rank.ace, suit: Suit.spade),
          Card(rank: Rank.king, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.heart),
          Card(rank: Rank.king, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.diamond),
          Card(rank: Rank.king, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.club),
          Card(rank: Rank.king, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.spade),
          Card(rank: Rank.queen, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.heart),
          Card(rank: Rank.queen, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.diamond),
          Card(rank: Rank.queen, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.club),
          Card(rank: Rank.queen, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.spade),
          Card(rank: Rank.jack, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.heart),
          Card(rank: Rank.jack, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.diamond),
          Card(rank: Rank.jack, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.club),
          Card(rank: Rank.jack, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.spade),
          Card(rank: Rank.ten, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.heart),
          Card(rank: Rank.ten, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.diamond),
          Card(rank: Rank.ten, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.club),
          Card(
            rank: Rank.ten,
            suit: Suit.club,
          ),
        )
      }),
    );
    expect(
      parseRangeString("84o+"),
      equals({
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.seven, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.seven, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.seven, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.seven, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.seven, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.seven, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.seven, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.seven, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.seven, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.club),
          Card(rank: Rank.seven, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.club),
          Card(rank: Rank.seven, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.club),
          Card(rank: Rank.seven, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.six, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.six, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.six, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.six, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.six, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.six, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.six, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.six, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.six, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.club),
          Card(rank: Rank.six, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.club),
          Card(rank: Rank.six, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.club),
          Card(rank: Rank.six, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.five, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.five, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.five, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.five, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.five, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.five, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.five, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.five, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.five, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.club),
          Card(rank: Rank.five, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.club),
          Card(rank: Rank.five, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.club),
          Card(rank: Rank.five, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.four, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.four, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.four, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.four, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.four, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.four, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.four, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.four, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.four, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.club),
          Card(rank: Rank.four, suit: Suit.spade),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.club),
          Card(rank: Rank.four, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.club),
          Card(rank: Rank.four, suit: Suit.diamond),
        )
      }),
    );
    expect(
      parseRangeString("66+"),
      equals({
        CardPair(
          Card(rank: Rank.ace, suit: Suit.spade),
          Card(rank: Rank.ace, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.spade),
          Card(rank: Rank.ace, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.spade),
          Card(rank: Rank.ace, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.heart),
          Card(rank: Rank.ace, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.heart),
          Card(rank: Rank.ace, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.ace, suit: Suit.diamond),
          Card(rank: Rank.ace, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.king, suit: Suit.spade),
          Card(rank: Rank.king, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.king, suit: Suit.spade),
          Card(rank: Rank.king, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.king, suit: Suit.spade),
          Card(rank: Rank.king, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.king, suit: Suit.heart),
          Card(rank: Rank.king, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.king, suit: Suit.heart),
          Card(rank: Rank.king, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.king, suit: Suit.diamond),
          Card(rank: Rank.king, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.queen, suit: Suit.spade),
          Card(rank: Rank.queen, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.queen, suit: Suit.spade),
          Card(rank: Rank.queen, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.queen, suit: Suit.spade),
          Card(rank: Rank.queen, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.queen, suit: Suit.heart),
          Card(rank: Rank.queen, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.queen, suit: Suit.heart),
          Card(rank: Rank.queen, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.queen, suit: Suit.diamond),
          Card(rank: Rank.queen, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.jack, suit: Suit.spade),
          Card(rank: Rank.jack, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.jack, suit: Suit.spade),
          Card(rank: Rank.jack, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.jack, suit: Suit.spade),
          Card(rank: Rank.jack, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.jack, suit: Suit.heart),
          Card(rank: Rank.jack, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.jack, suit: Suit.heart),
          Card(rank: Rank.jack, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.jack, suit: Suit.diamond),
          Card(rank: Rank.jack, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.ten, suit: Suit.spade),
          Card(rank: Rank.ten, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.ten, suit: Suit.spade),
          Card(rank: Rank.ten, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.ten, suit: Suit.spade),
          Card(rank: Rank.ten, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.ten, suit: Suit.heart),
          Card(rank: Rank.ten, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.ten, suit: Suit.heart),
          Card(rank: Rank.ten, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.ten, suit: Suit.diamond),
          Card(rank: Rank.ten, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.nine, suit: Suit.spade),
          Card(rank: Rank.nine, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.nine, suit: Suit.spade),
          Card(rank: Rank.nine, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.nine, suit: Suit.spade),
          Card(rank: Rank.nine, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.nine, suit: Suit.heart),
          Card(rank: Rank.nine, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.nine, suit: Suit.heart),
          Card(rank: Rank.nine, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.nine, suit: Suit.diamond),
          Card(rank: Rank.nine, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.eight, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.eight, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.spade),
          Card(rank: Rank.eight, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.eight, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.heart),
          Card(rank: Rank.eight, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.eight, suit: Suit.diamond),
          Card(rank: Rank.eight, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.seven, suit: Suit.spade),
          Card(rank: Rank.seven, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.seven, suit: Suit.spade),
          Card(rank: Rank.seven, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.seven, suit: Suit.spade),
          Card(rank: Rank.seven, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.seven, suit: Suit.heart),
          Card(rank: Rank.seven, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.seven, suit: Suit.heart),
          Card(rank: Rank.seven, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.seven, suit: Suit.diamond),
          Card(rank: Rank.seven, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.six, suit: Suit.spade),
          Card(rank: Rank.six, suit: Suit.heart),
        ),
        CardPair(
          Card(rank: Rank.six, suit: Suit.spade),
          Card(rank: Rank.six, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.six, suit: Suit.spade),
          Card(rank: Rank.six, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.six, suit: Suit.heart),
          Card(rank: Rank.six, suit: Suit.diamond),
        ),
        CardPair(
          Card(rank: Rank.six, suit: Suit.heart),
          Card(rank: Rank.six, suit: Suit.club),
        ),
        CardPair(
          Card(rank: Rank.six, suit: Suit.diamond),
          Card(rank: Rank.six, suit: Suit.club),
        )
      }),
    );
    expect(parseRangeString("J4+"), equals(parseRangeString("J4o+")));
    expect(
      parseRangeString("77+").union(parseRangeString("44+")),
      equals(parseRangeString("44+")),
    );
    expect(
      parseRangeString("8s7s8h7h8d7d8c7c"),
      equals(parseRangeString("87s")),
    );
    expect(
      parseRangeString("A2s+AQo+55+"),
      equals(parseRangeString("A2s+")
          .union(parseRangeString("AQo+"))
          .union(parseRangeString("55+"))),
    );
    expect(parseRangeString("A2s+AQo+55+").length, equals(132));
  });
}
