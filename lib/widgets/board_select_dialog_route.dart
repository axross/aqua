import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import '../models/card.dart' show Card;
import '../view_models/simulation_session.dart' show SimulationSession;
import './card_picker.dart' show CardPicker;
import './playing_card.dart' show PlayingCard, PlayingCardBack;

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
  ) =>
      Container(
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

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffffffff),
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
        builder: (context, board, _) => Column(
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
                          ? Color(0x3fff6b6b)
                          : Color(0x3fc8d6e5),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        fontFamily: "Rubik",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                        color: board.any((card) => card != null)
                            ? Color(0xffee5253)
                            : Color(0xff576574),
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
              unavailableCards: board.where((card) => card != null).toSet(),
              onCardTap: _onCardTapInPicker,
            ),
          ],
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
