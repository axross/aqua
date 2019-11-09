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

    return ValueListenableBuilder(
      valueListenable: simulationSession.playerHandSettings,
      builder: (context, playerHandSettings, _) {
        final playerHandSetting = playerHandSettings[index];

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (playerHandSetting is PlayerHoleCards) return;

                simulationSession.playerHandSettings.value = [
                  ...playerHandSettings
                ]..[index] = PlayerHoleCards();

                Analytics.of(context).logEvent(
                  name: "update_player_hand_setting_type",
                  parameters: {"to": "hole_cards"},
                );
              },
              child: Container(
                decoration: ShapeDecoration(
                  shape: StadiumBorder(),
                  color: playerHandSetting is PlayerHoleCards
                      ? Color(0xff54a0ff)
                      : Color(0x3f54a0ff),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Text(
                  "Certain Cards",
                  style: theme.textStyle.copyWith(
                    color: playerHandSetting is PlayerHoleCards
                        ? Color(0xffffffff)
                        : Color(0xff54a0ff),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                if (playerHandSetting is PlayerHandRange) return;

                simulationSession.playerHandSettings.value = [
                  ...playerHandSettings
                ]..[index] = PlayerHandRange.empty();

                Analytics.of(context).logEvent(
                  name: "update_player_hand_setting_type",
                  parameters: {"to": "range"},
                );
              },
              child: Container(
                decoration: ShapeDecoration(
                  shape: StadiumBorder(),
                  color: playerHandSetting is PlayerHandRange
                      ? Color(0xff1dd1a1)
                      : Color(0x3f1dd1a1),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Text(
                  "Range",
                  style: theme.textStyle.copyWith(
                    color: playerHandSetting is PlayerHandRange
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
