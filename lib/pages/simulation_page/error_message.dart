import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/models/simulator.dart';
import 'package:flutter/widgets.dart';

class ErrorMessage extends StatelessWidget {
  ErrorMessage({@required this.error, Key key}) : super(key: key);

  final SimulationCancelException error;

  @override
  Widget build(BuildContext context) {
    if (error == null) return SizedBox(width: 0, height: 0);

    final theme = AquaTheme.of(context);
    String message;
    TextStyle textStyle;

    if (error is InsafficientHandSettingException) {
      message = "At least 2 players to calculate";
      textStyle = theme.textStyle.copyWith(color: theme.dimForegroundColor);
    }

    if (error is InvalidBoardException) {
      message = "Set the board to be preflop, flop, turn or river to calculate";
      textStyle = theme.textStyle.copyWith(color: theme.errorForegroundColor);
    }

    if (error is IncompleteHandSettingException) {
      message = "Swipe to delete empty player to calculate";
      textStyle = theme.textStyle.copyWith(color: theme.errorForegroundColor);
    }

    if (error is NoPossibleCombinationException) {
      message =
          "No possible combination. Change any player's certain cards or range to calculate";
      textStyle = theme.textStyle.copyWith(color: theme.errorForegroundColor);
    }

    if (message == null || textStyle == null) {
      throw AssertionError("unreachable here.");
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Text(message, style: textStyle),
    );
  }
}
