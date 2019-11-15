import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_icons.dart';
import 'package:aqua/common_widgets/aqua_tab.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import './hand_range_tab_content.dart';
import './hole_cards_tab_content.dart';
import './preset_tab_content.dart';

class PlayerHandSettingPage extends StatefulWidget {
  @override
  _PlayerHandSettingPageState createState() => _PlayerHandSettingPageState();
}

class _PlayerHandSettingPageState extends State<PlayerHandSettingPage> {
  AquaTabController _controller;

  Function _listener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final simulationSession = Provider.of<SimulationSession>(context);
    final index = (ModalRoute.of(context).settings.arguments
        as Map<String, int>)["index"];

    if (_controller == null) {
      int initialSelectedTabIndex;

      switch (simulationSession.playerHandSettings.value[index].type) {
        case PlayerHandSettingType.holeCards:
          initialSelectedTabIndex = 0;
          break;
        case PlayerHandSettingType.handRange:
          initialSelectedTabIndex = 1;
          break;
      }

      _controller = AquaTabController(
        length: 3,
        initialSelectedTabIndex: initialSelectedTabIndex,
      );

      _listener = () {
        final playerHandSettings = simulationSession.playerHandSettings.value;
        final playerHandSetting = playerHandSettings[index];
        final selectedIndex = _controller.selectedIndex;

        switch (selectedIndex) {
          case 0:
            Analytics.of(context).logEvent(
              name: "update_player_hand_setting_type",
              parameters: {"to": "hole_cards"},
            );

            break;
          case 1:
            Analytics.of(context).logEvent(
              name: "update_player_hand_setting_type",
              parameters: {"to": "range"},
            );

            break;
          case 2:
            Analytics.of(context).logEvent(
              name: "update_player_hand_setting_type",
              parameters: {"to": "presets"},
            );

            break;
        }

        if (selectedIndex == 0 &&
            playerHandSetting.type != PlayerHandSettingType.holeCards) {
          simulationSession.playerHandSettings.value = [...playerHandSettings]
            ..[index] = PlayerHandSetting.emptyHoleCards();
        }

        if (selectedIndex == 1 &&
            playerHandSetting.type != PlayerHandSettingType.handRange) {
          simulationSession.playerHandSettings.value = [...playerHandSettings]
            ..[index] = PlayerHandSetting.emptyHandRange();
        }
      };

      _controller.addListener(_listener);
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = (ModalRoute.of(context).settings.arguments
        as Map<String, int>)["index"];
    final theme = AquaTheme.of(context);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            AquaTabView(
              controller: _controller,
              views: [
                HoleCardsTabContent(index: index),
                HandRangeTabContent(index: index),
                Flexible(
                  fit: FlexFit.loose,
                  child: PresetTabContent(index: index),
                ),
              ],
            ),
            SizedBox(height: 32),
            AquaTabBar(
              controller: _controller,
              tabs: [
                AquaTabItem(
                  label: "Cards",
                  icon: AquaIcons.holeCards,
                ),
                AquaTabItem(
                  label: "Range",
                  icon: AquaIcons.handRange,
                ),
                AquaTabItem(
                  label: "Presets",
                  icon: Feather.getIconData("save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    assert(_listener != null);

    _controller.removeListener(_listener);

    super.dispose();
  }
}
