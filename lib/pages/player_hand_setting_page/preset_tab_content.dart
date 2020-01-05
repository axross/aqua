import 'package:aqua/bundled_presets.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/readonly_range_grid.dart';
import 'package:aqua/common_widgets/tiny_stadium_button.dart';
import 'package:aqua/models/card_pair.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/player_hand_setting_preset.dart';
import 'package:aqua/utilities/number_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PresetTabContent extends StatelessWidget {
  PresetTabContent({
    this.playerHandSetting,
    this.onPresetSelected,
    Key key,
  })  : assert(playerHandSetting != null),
        assert(onPresetSelected != null),
        super(key: key);

  final PlayerHandSetting playerHandSetting;

  final void Function(PlayerHandSettingPreset) onPresetSelected;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints.deflate(EdgeInsets.only(top: 32)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TinyStadiumButton(
                    label: "Customize",
                    backgroundColor: theme.primaryBackgroundColor,
                    foregroundColor: theme.whiteForegroundColor,
                    onTap: () {
                      Navigator.of(context).pushNamed("/presets");
                    },
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Reference Hand Ranges",
                  style: theme.textStyle.copyWith(
                    fontSize: 20,
                    color: theme.foregroundColor,
                  ),
                ),
                SizedBox(height: 16),
                _BundledPresetList(
                  onTapped: (preset) => _onPresetTapped(context, preset),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _onPresetTapped(BuildContext context, PlayerHandSettingPreset preset) {
    onPresetSelected(preset);

    Navigator.of(context).pop();
  }
}

class _BundledPresetList extends StatelessWidget {
  _BundledPresetList({@required this.onTapped, Key key})
      : assert(onTapped != null),
        super(key: key);

  final void Function(PlayerHandSettingPreset) onTapped;

  @override
  Widget build(BuildContext context) => Column(
        children: List.generate(
          bundledPresets.length * 2 - 1,
          (i) => i % 2 == 0
              ? _PresetListItem(
                  preset: bundledPresets[i ~/ 2],
                  onTapped: () => onTapped(bundledPresets[i ~/ 2]),
                )
              : SizedBox(height: 16),
        ),
      );
}

class _PresetListItem extends StatelessWidget {
  _PresetListItem({@required this.preset, this.onTapped, Key key})
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
              Text(
                preset.name,
                style: theme.textStyle.copyWith(color: theme.foregroundColor),
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
        ],
      ),
    );
  }
}
