import 'package:aqua/models/card.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/utilities/system_ui_overlay_style.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:aqua/widgets/analytics.dart';
import 'package:aqua/widgets/aqua_theme.dart';
import 'package:aqua/widgets/card_picker.dart';
import 'package:aqua/widgets/playing_card.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BoardSelectDialogRoute<T> extends PopupRoute<T> {
  BoardSelectDialogRoute({
    @required this.simulationSession,
    RouteSettings settings,
  })  : assert(simulationSession != null),
        super(settings: settings);

  final SimulationSession simulationSession;

  @override
  final bool barrierDismissible = true;

  @override
  final String barrierLabel = 'Close';

  @override
  final Color barrierColor = Color(0x88000000);

  @override
  final Duration transitionDuration = const Duration(milliseconds: 300);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final theme = AquaTheme.of(context);

    setSystemUIOverlayStyle(
      topColor: theme.appBarBackgroundColor,
      bottomColor: theme.backgroundColor,
    );

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.125),
          end: Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        )),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticInOut,
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: double.infinity,
              child: DefaultTextStyle(
                style: TextStyle(decoration: TextDecoration.none),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final theme = AquaTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Provider.value(
          value: simulationSession,
          child: BoardSelectDialogPage(),
        ),
      ),
    );
  }
}

class BoardSelectDialogPage extends StatefulWidget {
  @override
  _BoardSelectDialogPageState createState() => _BoardSelectDialogPageState();
}

class _BoardSelectDialogPageState extends State<BoardSelectDialogPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final simulationSession = Provider.of<SimulationSession>(context);
    final theme = AquaTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ValueListenableBuilder<List<Card>>(
        valueListenable: simulationSession.board,
        builder: (context, board, _) => ValueListenableBuilder(
          valueListenable: simulationSession.playerHandSettings,
          builder: (context, playerHandSettings, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      simulationSession.board.value = [
                        null,
                        null,
                        null,
                        null,
                        null
                      ];

                      setState(() {
                        selectedIndex = 0;
                      });

                      Analytics.of(context).logEvent(
                        name: "clear_board_cards",
                      );
                    },
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: StadiumBorder(),
                        color: board.any((card) => card != null)
                            ? Color(0xffff6b6b)
                            : Color(0x3fc8d6e5),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: Text(
                        "Clear",
                        style: theme.textStyle.copyWith(
                          color: board.any((card) => card != null)
                              ? Color(0xffffffff)
                              : Color(0xffc8d6e5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: selectedIndex == 0 ? Color(0x7ffeca57) : null,
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
                  SizedBox(width: 4),
                  Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: selectedIndex == 1 ? Color(0x7ffeca57) : null,
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
                  SizedBox(width: 4),
                  Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: selectedIndex == 2 ? Color(0x7ffeca57) : null,
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
                  SizedBox(width: 12),
                  Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: selectedIndex == 3 ? Color(0x7ffeca57) : null,
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
                  SizedBox(width: 12),
                  Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: selectedIndex == 4 ? Color(0x7ffeca57) : null,
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
