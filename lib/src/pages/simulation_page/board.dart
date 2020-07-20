import 'package:aqua/src/common_widgets/playing_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:poker/poker.dart';

class Board extends StatelessWidget {
  Board({@required this.board, @required this.onPressed, Key key})
      : assert(board != null),
        assert(board.length == 5),
        assert(onPressed != null),
        super(key: key);

  final List<Card> board;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();

        onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 56,
              child: board[0] != null
                  ? PlayingCard(card: board[0])
                  : PlayingCardBack(),
            ),
            SizedBox(width: 8),
            SizedBox(
              width: 56,
              child: board[1] != null
                  ? PlayingCard(card: board[1])
                  : PlayingCardBack(),
            ),
            SizedBox(width: 8),
            SizedBox(
              width: 56,
              child: board[2] != null
                  ? PlayingCard(card: board[2])
                  : PlayingCardBack(),
            ),
            SizedBox(width: 16),
            SizedBox(
              width: 56,
              child: board[3] != null
                  ? PlayingCard(card: board[3])
                  : PlayingCardBack(),
            ),
            SizedBox(width: 16),
            SizedBox(
              width: 56,
              child: board[4] != null
                  ? PlayingCard(card: board[4])
                  : PlayingCardBack(),
            ),
          ],
        ),
      ),
    );
  }
}
