import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/models/TinyStadiumButton.dart';
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

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TinyStadiumButton(
              label: "Certain Cards",
              foregroundColor:
                  playerHandSetting.type == PlayerHandSettingType.holeCards
                      ? _holeCardsButtonSelectedForegroundColor
                      : _holeCardsButtonForegroundColor,
              backgroundColor:
                  playerHandSetting.type == PlayerHandSettingType.holeCards
                      ? _holeCardsButtonSelectedBackgroundColor
                      : _holeCardsButtonBackgroundColor,
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
            ),
            SizedBox(width: 16),
            TinyStadiumButton(
              label: "Range",
              foregroundColor:
                  playerHandSetting.type == PlayerHandSettingType.handRange
                      ? _handRangeButtonSelectedForegroundColor
                      : _handRangeButtonForegroundColor,
              backgroundColor:
                  playerHandSetting.type == PlayerHandSettingType.handRange
                      ? _handRangeButtonSelectedBackgroundColor
                      : _handRangeButtonBackgroundColor,
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
            ),
          ],
        );
      },
    );
  }
}

const _holeCardsButtonForegroundColor = Color(0xff54a0ff);
const _holeCardsButtonBackgroundColor = Color(0x3f54a0ff);
const _holeCardsButtonSelectedForegroundColor = Color(0xffffffff);
const _holeCardsButtonSelectedBackgroundColor = Color(0xff54a0ff);
const _handRangeButtonForegroundColor = Color(0xff1dd1a1);
const _handRangeButtonBackgroundColor = Color(0x3f1dd1a1);
const _handRangeButtonSelectedForegroundColor = Color(0xffffffff);
const _handRangeButtonSelectedBackgroundColor = Color(0xff1dd1a1);
