import 'package:aqua/models/card.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/utilities/system_ui_overlay_style.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:aqua/widgets/aqua_theme.dart';
import 'package:aqua/widgets/card_picker.dart';
import 'package:aqua/widgets/playing_card.dart';
import 'package:flutter/services.dart';
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
              child: child,
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
                        style: TextStyle(
                          fontFamily: "Rubik",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                          color: board.any((card) => card != null)
                              ? Color(0xffffffff)
                              : Color(0xffc8d6e5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(board.length * 2 - 1, (i) {
                  if (i % 2 == 1) return SizedBox(width: 4);

                  final index = i ~/ 2;

                  return Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: index == selectedIndex ? Color(0x7ffeca57) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () => _onCardTapToReplace(index),
                      child: board[index] == null
                          ? PlayingCardBack()
                          : PlayingCard(
                              card: board[index],
                            ),
                    ),
                  );
                }),
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

  void _onCardTapToReplace(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onCardTapInPicker(Card card) {
    if (selectedIndex == null) return;

    final simulationSession = Provider.of<SimulationSession>(context);

    simulationSession.board.value = [...simulationSession.board.value]
      ..[selectedIndex] = card;

    setState(() {
      selectedIndex = (selectedIndex + 1) % 5;
    });
  }
}
