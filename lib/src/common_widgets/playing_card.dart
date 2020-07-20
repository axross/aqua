import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/constants/card.dart";
import "package:flutter/widgets.dart";
import "package:poker/poker.dart";

class PlayingCard extends StatelessWidget {
  PlayingCard({Key key, @required this.card})
      : assert(card != null),
        super(key: key);

  final Card card;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    Color color;

    if (card.suit == Suit.spade) {
      color = theme.spadeForegroundColor;
    }

    if (card.suit == Suit.heart) {
      color = theme.heartForegroundColor;
    }

    if (card.suit == Suit.diamond) {
      color = theme.diamondForegroundColor;
    }

    if (card.suit == Suit.club) {
      color = theme.clubForegroundColor;
    }

    return AspectRatio(
      aspectRatio: 2.25 / 3.5,
      child: LayoutBuilder(
        builder: (_, constraints) => DecoratedBox(
          decoration: BoxDecoration(
            color: theme.dimBackgroundColor,
            borderRadius: BorderRadius.circular(constraints.maxWidth * 0.1),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  rankChars[card.rank],
                  style: theme.rankTextStyle.copyWith(
                    color: color,
                    fontSize: constraints.maxHeight * 0.45,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: constraints.maxHeight * 0.1,
                    left: constraints.maxWidth * 0.2,
                    right: constraints.maxWidth * 0.2,
                  ),
                  child: Image(
                    image: theme.assets.suits[card.suit],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayingCardBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return AspectRatio(
      aspectRatio: 2.25 / 3.5,
      child: LayoutBuilder(
        builder: (_, constraints) => Container(
          decoration: BoxDecoration(
            color: theme.dimBackgroundColor,
            borderRadius: BorderRadius.circular(constraints.maxWidth * 0.1),
          ),
        ),
      ),
    );
  }
}
