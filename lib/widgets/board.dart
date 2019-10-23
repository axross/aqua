import 'package:flutter/widgets.dart';
import '../models/card.dart';
import './playing_card.dart' show PlayingCard, PlayingCardBack;

class Board extends StatelessWidget {
  Board({this.cards, Key key})
      : assert(cards != null),
        assert(cards.length == 5),
        super(key: key);

  final List<Card> cards;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (cards[0] != null)
          PlayingCard(card: cards[0])
        else
          PlayingCardBack(),
        SizedBox(width: 16),
        if (cards[1] != null)
          PlayingCard(card: cards[1])
        else
          PlayingCardBack(),
        SizedBox(width: 16),
        if (cards[2] != null)
          PlayingCard(card: cards[2])
        else
          PlayingCardBack(),
        SizedBox(width: 16),
        if (cards[3] != null)
          PlayingCard(card: cards[3])
        else
          PlayingCardBack(),
        SizedBox(width: 16),
        if (cards[4] != null)
          PlayingCard(card: cards[4])
        else
          PlayingCardBack(),
      ],
    );
  }
}
