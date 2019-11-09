import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/card_picker.dart';
import 'package:aqua/common_widgets/playing_card.dart';
import 'package:aqua/models/card.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/view_models/simulation_session.dart';
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
          final playerHandSetting =
              playerHandSettings[widget.index] as PlayerHoleCards;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) {
                    final index = i ~/ 2;
                    return i % 2 == 0
                        ? Container(
                            width: 64,
                            decoration: BoxDecoration(
                              color: index == selectedIndex
                                  ? theme.highlightBackgroundColor
                                      .withOpacity(0.5)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(4),
                            child: GestureDetector(
                              onTap: () => _onCardTapToReplace(index),
                              child: playerHandSetting[index] == null
                                  ? PlayingCardBack()
                                  : PlayingCard(
                                      card: playerHandSetting[index],
                                    ),
                            ),
                          )
                        : SizedBox(width: 4);
                  },
                ),
              ),
              SizedBox(height: 32),
              CardPicker(
                unavailableCards: {
                  ...board,
                  ...playerHandSettings.whereType<PlayerHoleCards>().fold(
                      Set<Card>(),
                      (set, PlayerHoleCards playerHandSetting) =>
                          {...set, playerHandSetting[0], playerHandSetting[1]})
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
    setState(() {
      selectedIndex = index;
    });
  }

  void _onCardTapInPicker(Card card) {
    if (selectedIndex == null) return;

    final simulationSession = Provider.of<SimulationSession>(context);
    final handSetting = simulationSession.playerHandSettings.value[widget.index]
        as PlayerHoleCards;

    simulationSession.playerHandSettings.value = [
      ...simulationSession.playerHandSettings.value
    ]..[widget.index] = handSetting.copyWith(
        left: selectedIndex == 0 ? card : handSetting[0],
        right: selectedIndex == 1 ? card : handSetting[1],
      );

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
