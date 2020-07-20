import 'package:aqua/src/common_widgets/aqua_theme.dart';
import 'package:flutter/widgets.dart';

class ErrorMessage extends StatelessWidget {
  ErrorMessage({
    @required this.playerHandSettingLength,
    @required this.hasImcompletePlayerSetting,
    @required this.hasPossibleMatchup,
    Key key,
  }) : super(key: key);

  final int playerHandSettingLength;

  final bool hasImcompletePlayerSetting;

  final bool hasPossibleMatchup;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    String message;
    TextStyle textStyle;

    if (playerHandSettingLength < 2) {
      message = "At least 2 players to calculate";
      textStyle = theme.textStyle.copyWith(color: theme.dimForegroundColor);
    }

    if (hasImcompletePlayerSetting) {
      message = "Swipe to delete empty player to calculate";
      textStyle = theme.textStyle.copyWith(color: theme.errorForegroundColor);
    }

    if (!hasPossibleMatchup) {
      message =
          "No possible combination. Change any player's certain cards or range to calculate";
      textStyle = theme.textStyle.copyWith(color: theme.errorForegroundColor);
    }

    if (message == null || textStyle == null) {
      return SizedBox(width: 0, height: 0);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Text(message, style: textStyle),
    );
  }
}
