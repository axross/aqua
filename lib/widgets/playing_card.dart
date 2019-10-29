import 'package:aqua/models/card.dart';
import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';
import 'package:aqua/widgets/aqua_theme.dart';
import 'package:flutter/widgets.dart';

class PlayingCard extends StatelessWidget {
  PlayingCard({Key key, @required this.card})
      : assert(card != null),
        super(key: key);

  final Card card;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return AspectRatio(
      aspectRatio: 2.25 / 3.5,
      child: LayoutBuilder(
        builder: (_, constraints) => DecoratedBox(
          decoration: BoxDecoration(
            color: theme.playingCardBackgroundColor,
            borderRadius: BorderRadius.circular(constraints.maxWidth * 0.1),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  _rankStrings[card.rank],
                  style: theme.playingCardTextStyle.copyWith(
                    color: card.suit == Suit.spade || card.suit == Suit.club
                        ? theme.spadeForegroundColor
                        : theme.heartForegroundColor,
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
                  child: Image.asset(
                    _suitImages[card.suit],
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
            color: theme.playingCardBackgroundColor,
            borderRadius: BorderRadius.circular(constraints.maxWidth * 0.1),
          ),
        ),
      ),
    );
  }
}

final _rankStrings = {
  Rank.ace: "A",
  Rank.king: "K",
  Rank.queen: "Q",
  Rank.jack: "J",
  Rank.ten: "10",
  Rank.nine: "9",
  Rank.eight: "8",
  Rank.seven: "7",
  Rank.six: "6",
  Rank.five: "5",
  Rank.four: "4",
  Rank.three: "3",
  Rank.two: "2",
};

final _suitImages = {
  Suit.spade: "assets/images/spade.png",
  Suit.heart: "assets/images/heart.png",
  Suit.diamond: "assets/images/diamond.png",
  Suit.club: "assets/images/club.png",
};
