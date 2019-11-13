import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_icons.dart';
import 'package:aqua/common_widgets/aqua_tabs.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PlayerHandSettingTypeSelector extends StatelessWidget {
  PlayerHandSettingTypeSelector({@required this.index, Key key})
      : assert(index != null),
        super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    final simulationSession = Provider.of<SimulationSession>(context);

    return ValueListenableBuilder<List<PlayerHandSetting>>(
      valueListenable: simulationSession.playerHandSettings,
      builder: (context, playerHandSettings, _) {
        final playerHandSetting = playerHandSettings[index];

        const items = [
          AquaTabsItemData(label: "Cards", icon: AquaIcons.holeCards),
          AquaTabsItemData(label: "Range", icon: AquaIcons.handRange)
        ];

        return AquaTabs(
          items: items,
          initialIndex:
              playerHandSetting.type == PlayerHandSettingType.holeCards ? 0 : 1,
          onChanged: (i) {
            if (i == 0) {
              simulationSession.playerHandSettings.value = [
                ...playerHandSettings
              ]..[index] = PlayerHandSetting.emptyHoleCards();

              Analytics.of(context).logEvent(
                name: "update_player_hand_setting_type",
                parameters: {"to": "hole_cards"},
              );
            }

            if (i == 1) {
              simulationSession.playerHandSettings.value = [
                ...playerHandSettings
              ]..[index] = PlayerHandSetting.emptyHandRange();

              Analytics.of(context).logEvent(
                name: "update_player_hand_setting_type",
                parameters: {"to": "range"},
              );
            }
          },
        );
      },
    );
  }
}
