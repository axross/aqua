import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/readonly_range_grid.dart';
import 'package:aqua/models/card_pair.dart';
import 'package:aqua/models/player_hand_setting_preset.dart';
import 'package:aqua/utilities/number_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PresetListItem extends StatelessWidget {
  PresetListItem({@required this.preset, this.onTapped, Key key})
      : assert(preset != null),
        super(key: key);

  final PlayerHandSettingPreset preset;

  final void Function() onTapped;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final playerHandSetting = preset.toPlayerHandSetting();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();

        if (onTapped != null) {
          onTapped();
        }
      },
      child: Row(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(preset.name, style: theme.textStyle),
              SizedBox(height: 4),
              Text(
                "${formatOnlyWholeNumberPart(playerHandSetting.cardPairCombinations.length / numberOfAllHoleCardCombinations)}% combs",
                style: theme.textStyle.copyWith(
                  color: theme.secondaryBackgroundColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
