import "package:aqua/src/common_widgets/aqua_icons.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/fill.dart";
import "package:aqua/src/constants/card.dart";
import "package:flutter/widgets.dart";
import "package:poker/poker.dart";

class PlayingCard extends StatelessWidget {
  PlayingCard({Key? key, required this.card}) : super(key: key);

  final Card card;

  @override
  Widget build(BuildContext context) {
    final style = AquaTheme.of(context).playingCardStyle;

    return Fill(
      child: AspectRatio(
        aspectRatio: 2.25 / 3.5,
        child: LayoutBuilder(
          builder: (_, constraints) => DecoratedBox(
            decoration: BoxDecoration(
              color: style.backgroundColor,
              borderRadius: BorderRadius.circular(constraints.maxWidth * 0.1),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    rankChars[card.rank]!,
                    textAlign: TextAlign.center,
                    style: style.textStyle.copyWith(
                      color: style.suitColors[card.suit],
                      fontSize: constraints.maxHeight * 0.475,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: constraints.maxHeight * 0.05,
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Icon(
                        _suitIcons[card.suit],
                        color: style.suitColors[card.suit],
                        size: constraints.maxHeight * 0.475,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _suitIcons = {
  Suit.spade: AquaIcons.spade,
  Suit.heart: AquaIcons.heart,
  Suit.diamond: AquaIcons.diamond,
  Suit.club: AquaIcons.club,
};

class PlayingCardBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Fill(
      child: AspectRatio(
        aspectRatio: 2.25 / 3.5,
        child: LayoutBuilder(
          builder: (_, constraints) => Container(
            decoration: BoxDecoration(
              color: AquaTheme.of(context).playingCardStyle.backgroundColor,
              borderRadius: BorderRadius.circular(constraints.maxWidth * 0.1),
            ),
          ),
        ),
      ),
    );
  }
}
