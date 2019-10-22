import 'package:flutter/widgets.dart';
import '../models/card.dart' show Card, Rank, Suit;

class PlayingCard extends StatelessWidget {
  PlayingCard({Key key, @required this.card})
      : assert(card != null),
        super(key: key);

  final Card card;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.25 / 3.5,
      child: LayoutBuilder(
        builder: (_, constraints) => DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xffdfe6ed),
            borderRadius: BorderRadius.circular(constraints.maxWidth * 0.1),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  _rankStrings[card.rank],
                  style: TextStyle(
                    color: card.suit == Suit.spade || card.suit == Suit.club
                        ? Color(0xff464655)
                        : Color(0xffd2555a),
                    fontFamily: "WorkSans",
                    fontSize: constraints.maxHeight * 0.45,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
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
    return AspectRatio(
      aspectRatio: 2.25 / 3.5,
      child: LayoutBuilder(
        builder: (_, constraints) => Container(
          decoration: BoxDecoration(
            color: Color(0xffdfe6ed),
            borderRadius: BorderRadius.circular(constraints.maxWidth * 0.1),
          ),
        ),
      ),
    );
  }
}

const _rankStrings = {
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

const _suitImages = {
  Suit.spade: "assets/images/spade.png",
  Suit.heart: "assets/images/heart.png",
  Suit.diamond: "assets/images/diamond.png",
  Suit.club: "assets/images/club.png",
};
