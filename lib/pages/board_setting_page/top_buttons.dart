import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/tiny_stadium_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TopButtons extends StatelessWidget {
  TopButtons(
      {@required this.canClear, @required this.onClearButtonTapped, Key key})
      : assert(canClear != null),
        assert(onClearButtonTapped != null),
        super(key: key);

  final bool canClear;

  final void Function() onClearButtonTapped;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: TinyStadiumButton(
            label: "Clear",
            foregroundColor: canClear
                ? theme.whiteForegroundColor
                : theme.dimForegroundColor,
            backgroundColor: canClear
                ? theme.heartForegroundColor
                : theme.dimBackgroundColor,
            onTap: () {
              HapticFeedback.lightImpact();

              onClearButtonTapped();
            },
          ),
        ),
      ],
    );
  }
}
