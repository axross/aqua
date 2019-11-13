import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/card_picker.dart';
import 'package:aqua/common_widgets/playing_card.dart';
import 'package:aqua/models/card.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PlayerHoleCardSelect extends StatefulWidget {
  PlayerHoleCardSelect({this.index, Key key})
      : assert(index != null),
        super(key: key);

  final int index;

  @override
  _PlayerHoleCardSelectState createState() => _PlayerHoleCardSelectState();
}

class _PlayerHoleCardSelectState extends State<PlayerHoleCardSelect> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final simulationSession = Provider.of<SimulationSession>(context);

    return ValueListenableBuilder<List<Card>>(
      valueListenable: simulationSession.board,
      builder: (context, board, _) =>
          ValueListenableBuilder<List<PlayerHandSetting>>(
        valueListenable: simulationSession.playerHandSettings,
        builder: (context, playerHandSettings, _) {
          final playerHandSetting = playerHandSettings[widget.index];

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: selectedIndex == 0
                          ? theme.highlightBackgroundColor.withOpacity(0.5)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () => _onCardTapToReplace(0),
                      child: playerHandSetting.onlyHoleCards.left == null
                          ? PlayingCardBack()
                          : PlayingCard(
                              card: playerHandSetting.onlyHoleCards.left,
                            ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: selectedIndex == 1
                          ? theme.highlightBackgroundColor.withOpacity(0.5)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () => _onCardTapToReplace(1),
                      child: playerHandSetting.onlyHoleCards.right == null
                          ? PlayingCardBack()
                          : PlayingCard(
                              card: playerHandSetting.onlyHoleCards.right,
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              CardPicker(
                unavailableCards: {
                  ...board,
                  ...playerHandSettings
                      .where((playerHandSetting) =>
                          playerHandSetting.type ==
                          PlayerHandSettingType.holeCards)
                      .fold<Set<Card>>(
                        Set<Card>(),
                        (set, playerHandSetting) => set
                          ..add(playerHandSetting.onlyHoleCards.left)
                          ..add(playerHandSetting.onlyHoleCards.right),
                      ),
                },
                onCardTap: _onCardTapInPicker,
              ),
            ],
          );
        },
      ),
    );
  }

  void _onCardTapToReplace(int index) {
    HapticFeedback.lightImpact();

    setState(() {
      selectedIndex = index;
    });
  }

  void _onCardTapInPicker(Card card) {
    if (selectedIndex == null) return;

    final simulationSession = Provider.of<SimulationSession>(context);
    final handSetting =
        simulationSession.playerHandSettings.value[widget.index];

    simulationSession.playerHandSettings.value = [
      ...simulationSession.playerHandSettings.value
    ]..[widget.index] = PlayerHandSetting(parts: {
        HoleCards(
          left: selectedIndex == 0 ? card : handSetting.onlyHoleCards.left,
          right: selectedIndex == 1 ? card : handSetting.onlyHoleCards.right,
        )
      });

    setState(() {
      selectedIndex = (selectedIndex + 1) % 2;
    });

    Analytics.of(context).logEvent(
      name: "update_player_hand_setting",
      parameters: {
        "type": "hole_cards",
        "index": selectedIndex,
      },
    );
  }
}
