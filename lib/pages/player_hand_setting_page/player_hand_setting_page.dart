import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_icons.dart';
import 'package:aqua/common_widgets/aqua_tab.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/view_models/player_hand_setting.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
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

  int _index;

  SimulationSession _simulationSession;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_index == null) {
      _index = (ModalRoute.of(context).settings.arguments
          as Map<String, int>)["index"];
    }

    if (_simulationSession == null) {
      _simulationSession = SimulationSessionProvider.of(context);
    }

    if (_controller == null) {
      final playerHandSetting = _simulationSession.playerHandSettings[_index];
      int initialSelectedTabIndex;

      switch (playerHandSetting.type) {
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
        final playerHandSetting = _simulationSession.playerHandSettings[_index];
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
          _simulationSession.playerHandSettings[_index].type =
              PlayerHandSettingType.holeCards;
        }

        if (selectedIndex == 1 &&
            playerHandSetting.type != PlayerHandSettingType.handRange) {
          _simulationSession.playerHandSettings[_index].type =
              PlayerHandSettingType.handRange;
        }

        if (selectedIndex == 2 &&
            playerHandSetting.type != PlayerHandSettingType.handRange) {
          _simulationSession.playerHandSettings[_index].type =
              PlayerHandSettingType.handRange;
        }
      };

      _controller.addListener(_listener);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Flexible(
              fit: FlexFit.loose,
              child: AnimatedBuilder(
                animation: _simulationSession,
                builder: (context, _) => AquaTabView(
                  controller: _controller,
                  views: [
                    HoleCardsTabContent(
                      playerHandSetting:
                          _simulationSession.playerHandSettings[_index],
                      unavailableCards: _simulationSession.usedCards,
                      onCardPicked: (left, right) {
                        _simulationSession.setInitialHoleCardPairAt(
                          _index,
                          left,
                          right,
                        );
                      },
                    ),
                    HandRangeTabContent(
                      playerHandSetting:
                          _simulationSession.playerHandSettings[_index],
                      onChanged: (handRange, {@required String via}) {
                        _simulationSession.setHandRangeAt(
                          _index,
                          handRange,
                          via: via,
                        );
                      },
                    ),
                    PresetTabContent(
                      playerHandSetting:
                          _simulationSession.playerHandSettings[_index],
                      onPresetSelected: (preset) {
                        _simulationSession.setPlayerHandSettingFromPresetAt(
                          _index,
                          preset,
                          via: "preset",
                        );
                      },
                    ),
                  ],
                ),
              ),
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
