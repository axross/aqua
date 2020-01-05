import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/readonly_range_grid.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';

class NewPresetListItem extends StatefulWidget {
  NewPresetListItem({
    this.onPressed,
    Key key,
  }) : super(key: key);

  final void Function() onPressed;

  @override
  State<NewPresetListItem> createState() => _NewPresetListItemState();
}

class _NewPresetListItemState extends State<NewPresetListItem> {
  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();

        if (widget.onPressed != null) {
          widget.onPressed();
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: ReadonlyRangeGrid(handRange: {}),
          ),
          SizedBox(width: 8),
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
                    "Tap to add a new preset",
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
