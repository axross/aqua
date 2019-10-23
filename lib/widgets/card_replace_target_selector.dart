import 'package:flutter/widgets.dart';
import '../models/card.dart';
import './playing_card.dart' show PlayingCard, PlayingCardBack;

class CardReplaceTargetSelector extends StatelessWidget {
  CardReplaceTargetSelector({
    Key key,
    @required this.cards,
    this.selectedIndex,
    this.onCardTap,
  })  : assert(cards != null),
        assert(cards.length >= 1),
        assert(selectedIndex == null ||
            selectedIndex >= 0 && selectedIndex < cards.length),
        super(key: key);

  final Iterable<Card> cards;

  final int selectedIndex;

  final void Function(int index) onCardTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(cards.length * 2 - 1, (i) {
        if (i % 2 == 1) return SizedBox(width: 4);

        final index = i ~/ 2;

        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: index == selectedIndex ? Color(0x7ffeca57) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(4),
            child: GestureDetector(
              onTap: () => _onCardTap(index),
              child: cards.elementAt(index) == null
                  ? PlayingCardBack()
                  : PlayingCard(
                      card: cards.elementAt(index),
                    ),
            ),
          ),
        );
      }),
    );
  }

  _onCardTap(int index) {
    if (onCardTap != null) {
      onCardTap(index);
    }
  }
}
