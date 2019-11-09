import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/view_models/simulation_session.dart';
import "package:flutter/widgets.dart";
import 'package:provider/provider.dart';
import './player_hand_setting_type_selector.dart';
import './player_hand_range_select.dart';
import './player_hole_card_select.dart';

class PlayerHandSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final index = (ModalRoute.of(context).settings.arguments
        as Map<String, int>)["index"];
    final theme = AquaTheme.of(context);
    final simulationSession = Provider.of<SimulationSession>(context);

    return ValueListenableBuilder<List<PlayerHandSetting>>(
      valueListenable: simulationSession.playerHandSettings,
      builder: (context, playerHandSettings, _) {
        final playerHandSetting = playerHandSettings[index];

        return Container(
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          padding: EdgeInsets.all(16),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlayerHandSettingTypeSelector(index: index),
                SizedBox(height: 32),
                if (playerHandSetting.type == PlayerHandSettingType.holeCards)
                  PlayerHoleCardSelect(index: index),
                if (playerHandSetting.type == PlayerHandSettingType.handRange)
                  PlayerHandRangeSelect(index: index),
              ],
            ),
          ),
        );
      },
    );
  }
}
