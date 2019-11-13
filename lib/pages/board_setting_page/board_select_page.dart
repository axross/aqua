import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/card_picker.dart';
import 'package:aqua/common_widgets/playing_card.dart';
import 'package:aqua/models/card.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import './top_buttons.dart';

class BoardSettingPage extends StatefulWidget {
  @override
  _BoardSettingPageState createState() => _BoardSettingPageState();
}

class _BoardSettingPageState extends State<BoardSettingPage> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final simulationSession = Provider.of<SimulationSession>(context);
      final firstNullIndex =
          simulationSession.board.value.indexWhere((card) => card == null);

      if (firstNullIndex != -1) {
        setState(() {
          selectedIndex = firstNullIndex;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final simulationSession = Provider.of<SimulationSession>(context);
    final theme = AquaTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16),
      child: SafeArea(
        top: false,
        child: ValueListenableBuilder<List<Card>>(
          valueListenable: simulationSession.board,
          builder: (context, board, _) =>
              ValueListenableBuilder<List<PlayerHandSetting>>(
            valueListenable: simulationSession.playerHandSettings,
            builder: (context, playerHandSettings, _) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopButtons(
                  onClearButtonTapped: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      decoration: BoxDecoration(
                        color: selectedIndex == 0
                            ? theme.highlightBackgroundColor
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: () => _onCardTapToReplace(0),
                        child: board[0] == null
                            ? PlayingCardBack()
                            : PlayingCard(
                                card: board[0],
                              ),
                      ),
                    ),
                    Container(
                      width: 64,
                      decoration: BoxDecoration(
                        color: selectedIndex == 1
                            ? theme.highlightBackgroundColor
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: () => _onCardTapToReplace(1),
                        child: board[1] == null
                            ? PlayingCardBack()
                            : PlayingCard(
                                card: board[1],
                              ),
                      ),
                    ),
                    Container(
                      width: 64,
                      decoration: BoxDecoration(
                        color: selectedIndex == 2
                            ? theme.highlightBackgroundColor
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: () => _onCardTapToReplace(2),
                        child: board[2] == null
                            ? PlayingCardBack()
                            : PlayingCard(
                                card: board[2],
                              ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 64,
                      decoration: BoxDecoration(
                        color: selectedIndex == 3
                            ? theme.highlightBackgroundColor
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: () => _onCardTapToReplace(3),
                        child: board[3] == null
                            ? PlayingCardBack()
                            : PlayingCard(
                                card: board[3],
                              ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 64,
                      decoration: BoxDecoration(
                        color: selectedIndex == 4
                            ? theme.highlightBackgroundColor
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: () => _onCardTapToReplace(4),
                        child: board[4] == null
                            ? PlayingCardBack()
                            : PlayingCard(
                                card: board[4],
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CardPicker(
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
                                ..add(playerHandSetting.onlyHoleCards.right))
                    },
                    onCardTap: _onCardTapInPicker,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCardTapToReplace(int index) => setState(() {
        selectedIndex = index;
      });

  void _onCardTapInPicker(Card card) {
    if (selectedIndex == null) return;

    final simulationSession = Provider.of<SimulationSession>(context);

    simulationSession.board.value = [...simulationSession.board.value]
      ..[selectedIndex] = card;

    setState(() {
      selectedIndex = (selectedIndex + 1) % 5;
    });

    Analytics.of(context).logEvent(
      name: "update_board_cards",
      parameters: {"next_length": simulationSession.board.value.length},
    );
  }
}
