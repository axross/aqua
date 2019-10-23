import 'package:flutter/widgets.dart';
import '../models/card.dart' show Card, Rank, Suit;
// import '../models/suit.dart' show Suit;
import './playing_card.dart' show PlayingCard, PlayingCardBack;

class CardSelector extends StatefulWidget {
  CardSelector({Key key, @required this.length, this.initial, this.onSelected})
      : assert(length != null),
        assert(length >= 1),
        assert(initial == null || initial.length <= length),
        super(key: key);

  final int length;

  final List<Card> initial;

  final void Function(List<Card>) onSelected;

  @override
  _CardSelectorState createState() => _CardSelectorState();
}

class _CardSelectorState extends State<CardSelector> {
  List<Card> cards;
  int selectedCardIndexToReplace;

  @override
  void initState() {
    super.initState();

    cards = List.generate(widget.length, (_) => null);

    if (widget.initial != null) {
      for (final entry in widget.initial.asMap().entries) {
        cards[entry.key] = entry.value;
      }
    }

    selectedCardIndexToReplace = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: List.generate(widget.length * 2 - 1, (i) {
          if (i % 2 == 1) return SizedBox(width: 4);

          final cardIndex = i ~/ 2;

          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cardIndex == selectedCardIndexToReplace
                    ? Color(0x7ffeca57)
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(4),
              child: GestureDetector(
                onTap: () {
                  selectedCardIndexToReplace = cardIndex;
                },
                child: cards[cardIndex] == null
                    ? PlayingCardBack()
                    : PlayingCard(
                        card: cards[cardIndex],
                      ),
              ),
            ),
          );
        }),
      ),
      SizedBox(height: 32),
      Column(
        children: List.generate(
          _cards.length * 2 - 1,
          (i) => i % 2 == 0
              ? Row(
                  children: List.generate(
                    _cards[i ~/ 2].length * 2 - 1,
                    (j) => j % 2 == 0
                        ? Expanded(
                            child: cards.contains(_cards[i ~/ 2][j ~/ 2])
                                ? Opacity(
                                    opacity: 0.25,
                                    child: PlayingCard(
                                      card: _cards[i ~/ 2][j ~/ 2],
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () =>
                                        _onCardTap(_cards[i ~/ 2][j ~/ 2]),
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
      )
    ]);
  }

  _onCardTap(Card card) {
    if (selectedCardIndexToReplace == null) return;

    setState(() {
      cards[selectedCardIndexToReplace] = card;
    });

    if (widget.onSelected != null) {
      widget.onSelected(cards);
    }
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
