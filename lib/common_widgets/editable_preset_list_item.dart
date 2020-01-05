import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/plain_text_field.dart';
import 'package:aqua/common_widgets/readonly_range_grid.dart';
import 'package:aqua/models/card_pair.dart';
import 'package:aqua/models/player_hand_setting_preset.dart';
import 'package:aqua/utilities/number_format.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class EditablePresetListItem extends StatelessWidget {
  EditablePresetListItem({
    @required this.preset,
    this.onPressed,
    this.onNameEditEnd,
    Key key,
  })  : assert(preset != null),
        super(key: key);

  final PlayerHandSettingPreset preset;

  final void Function() onPressed;

  final void Function(String) onNameEditEnd;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final playerHandSetting = preset.toPlayerHandSetting();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();

        if (onPressed != null) {
          onPressed();
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: ReadonlyRangeGrid(
              handRange: playerHandSetting.onlyHandRange,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                PlainTextField(
                  style: theme.textStyle,
                  initialValue: preset.name ?? "",
                  placeholder: "Tap here to name",
                  onUnfocused: (text) {
                    if (onNameEditEnd != null) {
                      onNameEditEnd(text.isEmpty ? null : text);
                    }
                  },
                ),
                SizedBox(height: 4),
                Text(
                  "${formatOnlyWholeNumberPart(playerHandSetting.cardPairCombinations.length / numberOfAllHoleCardCombinations)}% combs",
                  style: theme.textStyle.copyWith(
                    color: theme.dimForegroundColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
