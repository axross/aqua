import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/card_picker.dart';
import 'package:aqua/common_widgets/playing_card.dart';
import 'package:aqua/models/card.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class HoleCardsTabContent extends StatefulWidget {
  HoleCardsTabContent({
    @required this.playerHandSetting,
    @required this.unavailableCards,
    @required this.onCardPicked,
    Key key,
  })  : assert(playerHandSetting != null),
        assert(unavailableCards != null),
        assert(onCardPicked != null),
        super(key: key);

  final PlayerHandSetting playerHandSetting;

  final Set<Card> unavailableCards;

  final void Function(Card, Card) onCardPicked;

  @override
  _HoleCardsTabContentState createState() => _HoleCardsTabContentState();
}

class _HoleCardsTabContentState extends State<HoleCardsTabContent> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              decoration: BoxDecoration(
                color:
                    selectedIndex == 0 ? theme.highlightBackgroundColor : null,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(4),
              child: GestureDetector(
                onTap: () => _onCardTapToReplace(0),
                child: widget.playerHandSetting.onlyHoleCards.left == null
                    ? PlayingCardBack()
                    : PlayingCard(
                        card: widget.playerHandSetting.onlyHoleCards.left,
                      ),
              ),
            ),
            SizedBox(width: 4),
            Container(
              width: 64,
              decoration: BoxDecoration(
                color:
                    selectedIndex == 1 ? theme.highlightBackgroundColor : null,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(4),
              child: GestureDetector(
                onTap: () => _onCardTapToReplace(1),
                child: widget.playerHandSetting.onlyHoleCards.right == null
                    ? PlayingCardBack()
                    : PlayingCard(
                        card: widget.playerHandSetting.onlyHoleCards.right,
                      ),
              ),
            ),
          ],
        ),
        SizedBox(height: 32),
        CardPicker(
          unavailableCards: widget.unavailableCards,
          onCardTap: _onCardPicked,
        ),
      ],
    );
  }

  void _onCardTapToReplace(int index) {
    HapticFeedback.lightImpact();

    setState(() {
      selectedIndex = index;
    });
  }

  void _onCardPicked(Card card) {
    if (selectedIndex == null) return;

    if (selectedIndex == 0) {
      widget.onCardPicked(card, widget.playerHandSetting.onlyHoleCards.right);
    } else {
      widget.onCardPicked(widget.playerHandSetting.onlyHoleCards.left, card);
    }

    setState(() {
      selectedIndex = (selectedIndex + 1) % 2;
    });
  }
}
