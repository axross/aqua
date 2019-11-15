import 'package:aqua/bundled_presets.dart';
import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/preset_list_item.dart';
import 'package:aqua/models/player_hand_setting_preset.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PresetTabContent extends StatelessWidget {
  PresetTabContent({this.index, Key key})
      : assert(index != null),
        super(key: key);

  final int index;

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
                Text(
                  "Reference Hand Ranges",
                  style: theme.textStyle.copyWith(fontSize: 20),
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
    final simulationSession = Provider.of<SimulationSession>(context);

    simulationSession.playerHandSettings.value = [
      ...simulationSession.playerHandSettings.value
    ]..[index] = preset.toPlayerHandSetting();

    Analytics.of(context).logEvent(
      name: "update_player_hand_setting",
      parameters: {
        "type": "range",
        "length": preset.parts.length,
        "via": "preset",
        "is_custom": false,
      },
    );

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
              ? PresetListItem(
                  preset: bundledPresets[i ~/ 2],
                  onTapped: () => onTapped(bundledPresets[i ~/ 2]),
                )
              : SizedBox(height: 16),
        ),
      );
}
