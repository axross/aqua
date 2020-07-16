import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:poker/poker.dart';

class AppBarIshBar extends StatelessWidget {
  AppBarIshBar({@required this.board, Key key})
      : assert(board != null),
        super(key: key);

  final List<Card> board;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Container(
      color: theme.dimBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 56,
          child: Center(
            child: Text(
              () {
                switch (board.indexOf(null)) {
                  case 0:
                    return "Odds at Preflop";
                  case 3:
                    return "Odds at Flop";
                  case 4:
                    return "Odds at Turn";
                  case -1:
                    return "Odds at River";
                  default:
                    return "Odds Calculation";
                }
              }(),
              style: theme.appBarTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
