import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
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
    final theme = AquaTheme.of(context);
    final simulationSession = Provider.of<SimulationSession>(context);

    return ValueListenableBuilder<List<PlayerHandSetting>>(
      valueListenable: simulationSession.playerHandSettings,
      builder: (context, playerHandSettings, _) {
        final playerHandSetting = playerHandSettings[index];

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: playerHandSetting.type != PlayerHandSettingType.holeCards
                  ? () {
                      simulationSession.playerHandSettings.value = [
                        ...playerHandSettings
                      ]..[index] = PlayerHandSetting.emptyHoleCards();

                      Analytics.of(context).logEvent(
                        name: "update_player_hand_setting_type",
                        parameters: {"to": "hole_cards"},
                      );
                    }
                  : null,
              child: Container(
                decoration: ShapeDecoration(
                  shape: StadiumBorder(),
                  color:
                      playerHandSetting.type == PlayerHandSettingType.holeCards
                          ? Color(0xff54a0ff)
                          : Color(0x3f54a0ff),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Text(
                  "Certain Cards",
                  style: theme.textStyle.copyWith(
                    color: playerHandSetting.type ==
                            PlayerHandSettingType.holeCards
                        ? Color(0xffffffff)
                        : Color(0xff54a0ff),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: playerHandSetting.type != PlayerHandSettingType.handRange
                  ? () {
                      simulationSession.playerHandSettings.value = [
                        ...playerHandSettings
                      ]..[index] = PlayerHandSetting.emptyHandRange();

                      Analytics.of(context).logEvent(
                        name: "update_player_hand_setting_type",
                        parameters: {"to": "range"},
                      );
                    }
                  : null,
              child: Container(
                decoration: ShapeDecoration(
                  shape: StadiumBorder(),
                  color:
                      playerHandSetting.type == PlayerHandSettingType.handRange
                          ? Color(0xff1dd1a1)
                          : Color(0x3f1dd1a1),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Text(
                  "Range",
                  style: theme.textStyle.copyWith(
                    color: playerHandSetting.type ==
                            PlayerHandSettingType.handRange
                        ? Color(0xffffffff)
                        : Color(0xff1dd1a1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
