import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_icons.dart';
import 'package:aqua/common_widgets/aqua_tab.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/view_models/simulation_session.dart';
import "package:flutter/widgets.dart";
import 'package:provider/provider.dart';
import './player_hand_range_select.dart';
import './player_hole_card_select.dart';

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
        length: 2,
        initialSelectedTabIndex: initialSelectedTabIndex,
      );

      _listener = () {
        final playerHandSettings = simulationSession.playerHandSettings.value;
        final playerHandSetting = playerHandSettings[index];
        final selectedIndex = _controller.selectedIndex;

        if (selectedIndex == 0 &&
            playerHandSetting.type != PlayerHandSettingType.holeCards) {
          simulationSession.playerHandSettings.value = [...playerHandSettings]
            ..[index] = PlayerHandSetting.emptyHoleCards();
          Analytics.of(context).logEvent(
            name: "update_player_hand_setting_type",
            parameters: {"to": "hole_cards"},
          );
        }

        if (selectedIndex == 1 &&
            playerHandSetting.type != PlayerHandSettingType.handRange) {
          simulationSession.playerHandSettings.value = [...playerHandSettings]
            ..[index] = PlayerHandSetting.emptyHandRange();
          Analytics.of(context).logEvent(
            name: "update_player_hand_setting_type",
            parameters: {"to": "range"},
          );
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
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            AquaTabView(
              controller: _controller,
              views: [
                PlayerHoleCardSelect(index: index),
                PlayerHandRangeSelect(index: index),
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
