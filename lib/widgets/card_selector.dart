import 'package:flutter/widgets.dart';
import '../models/card.dart' show Card, Rank, Suit;
import './playing_card.dart' show PlayingCard;

typedef OnTap = void Function(Card);

class CardSelector extends StatelessWidget {
  CardSelector({Key key, this.unavailableCards, this.onTap}) : super(key: key);

  final Set<Card> unavailableCards;
  final OnTap onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        _cards.length * 2 - 1,
        (i) => i % 2 == 0
            ? Row(
                children: List.generate(
                  _cards[i ~/ 2].length * 2 - 1,
                  (j) => j % 2 == 0
                      ? Expanded(
                          child:
                              unavailableCards.contains(_cards[i ~/ 2][j ~/ 2])
                                  ? Opacity(
                                      opacity: 0.25,
                                      child: PlayingCard(
                                        card: _cards[i ~/ 2][j ~/ 2],
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () => onTap != null
                                          ? onTap(_cards[i ~/ 2][j ~/ 2])
                                          : null,
                                      child: PlayingCard(
                                        card: _cards[i ~/ 2][j ~/ 2],
                                      ),
                                    ),
                        )
                      : SizedBox(width: 2),
                ),
              )
            : SizedBox(height: 2),
      ),
    );
  }
}

final _cards = [
  [
    Card(rank: Rank.ace, suit: Suit.spade),
    Card(rank: Rank.king, suit: Suit.spade),
    Card(rank: Rank.queen, suit: Suit.spade),
    Card(rank: Rank.jack, suit: Suit.spade),
    Card(rank: Rank.ten, suit: Suit.spade),
    Card(rank: Rank.nine, suit: Suit.spade),
    Card(rank: Rank.eight, suit: Suit.spade),
    Card(rank: Rank.seven, suit: Suit.spade),
    Card(rank: Rank.six, suit: Suit.spade),
    Card(rank: Rank.five, suit: Suit.spade),
    Card(rank: Rank.four, suit: Suit.spade),
    Card(rank: Rank.three, suit: Suit.spade),
    Card(rank: Rank.two, suit: Suit.spade),
  ],
  [
    Card(rank: Rank.ace, suit: Suit.heart),
    Card(rank: Rank.king, suit: Suit.heart),
    Card(rank: Rank.queen, suit: Suit.heart),
    Card(rank: Rank.jack, suit: Suit.heart),
    Card(rank: Rank.ten, suit: Suit.heart),
    Card(rank: Rank.nine, suit: Suit.heart),
    Card(rank: Rank.eight, suit: Suit.heart),
    Card(rank: Rank.seven, suit: Suit.heart),
    Card(rank: Rank.six, suit: Suit.heart),
    Card(rank: Rank.five, suit: Suit.heart),
    Card(rank: Rank.four, suit: Suit.heart),
    Card(rank: Rank.three, suit: Suit.heart),
    Card(rank: Rank.two, suit: Suit.heart),
  ],
  [
    Card(rank: Rank.ace, suit: Suit.diamond),
    Card(rank: Rank.king, suit: Suit.diamond),
    Card(rank: Rank.queen, suit: Suit.diamond),
    Card(rank: Rank.jack, suit: Suit.diamond),
    Card(rank: Rank.ten, suit: Suit.diamond),
    Card(rank: Rank.nine, suit: Suit.diamond),
    Card(rank: Rank.eight, suit: Suit.diamond),
    Card(rank: Rank.seven, suit: Suit.diamond),
    Card(rank: Rank.six, suit: Suit.diamond),
    Card(rank: Rank.five, suit: Suit.diamond),
    Card(rank: Rank.four, suit: Suit.diamond),
    Card(rank: Rank.three, suit: Suit.diamond),
    Card(rank: Rank.two, suit: Suit.diamond),
  ],
  [
    Card(rank: Rank.ace, suit: Suit.club),
    Card(rank: Rank.king, suit: Suit.club),
    Card(rank: Rank.queen, suit: Suit.club),
    Card(rank: Rank.jack, suit: Suit.club),
    Card(rank: Rank.ten, suit: Suit.club),
    Card(rank: Rank.nine, suit: Suit.club),
    Card(rank: Rank.eight, suit: Suit.club),
    Card(rank: Rank.seven, suit: Suit.club),
    Card(rank: Rank.six, suit: Suit.club),
    Card(rank: Rank.five, suit: Suit.club),
    Card(rank: Rank.four, suit: Suit.club),
    Card(rank: Rank.three, suit: Suit.club),
    Card(rank: Rank.two, suit: Suit.club),
  ],
];
