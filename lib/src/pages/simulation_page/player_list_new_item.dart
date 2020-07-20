import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/playing_card.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:flutter_icons/flutter_icons.dart";

class PlayerListNewItem extends StatelessWidget {
  PlayerListNewItem({@required this.onPressed, Key key})
      : assert(onPressed != null),
        super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();

        onPressed();
      },
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: PlayingCardBack(),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: PlayingCardBack(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(
                    Feather.getIconData("plus-circle"),
                    size: 20,
                    color: theme.dimForegroundColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Tap here to add player",
                    style: theme.textStyle
                        .copyWith(color: theme.dimForegroundColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
