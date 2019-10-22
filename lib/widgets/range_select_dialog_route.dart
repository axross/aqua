import "package:flutter/widgets.dart";
import 'package:provider/provider.dart';
import '../models/card.dart' show Card;
import '../view_models/simulation_session.dart' show SimulationSession;
import '../models/player_hand_setting.dart'
    show PlayerHandRange, PlayerHoleCards;
import './card_selector.dart' show CardSelector;
import './playing_card.dart' show PlayingCard, PlayingCardBack;
import './range_grid.dart' show RangeSelectGrid;

class RangeSelectDialogRoute<T> extends PopupRoute<T> {
  RangeSelectDialogRoute({
    @required this.simulationSession,
    @required this.index,
    RouteSettings settings,
  })  : assert(simulationSession != null),
        assert(index != null),
        super(settings: settings);

  final SimulationSession simulationSession;

  final int index;

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
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: SafeArea(
        top: false,
        child: Provider.value(
          value: simulationSession,
          child: PlayerHandRangeSettingPage(index: index),
        ),
      ),
    );
  }
}

class PlayerHandRangeSettingPage extends StatelessWidget {
  PlayerHandRangeSettingPage({@required this.index, Key key})
      : assert(index != null),
        super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final simulationSession = Provider.of<SimulationSession>(context);

    return AnimatedBuilder(
      animation: simulationSession.handSettings,
      builder: (context, _) {
        final handSetting = simulationSession.handSettings[index];

        return Padding(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: handSetting is! PlayerHoleCards
                        ? () {
                            simulationSession.handSettings[index] =
                                PlayerHoleCards();
                          }
                        : null,
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: StadiumBorder(),
                        color: handSetting is PlayerHoleCards
                            ? Color(0x3f54a0ff)
                            : Color(0x3fc8d6e5),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: Text(
                        "Certain Cards",
                        style: TextStyle(
                          fontFamily: "WorkSans",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                          color: handSetting is PlayerHoleCards
                              ? Color(0xff2e86de)
                              : Color(0xff576574),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: handSetting is! PlayerHandRange
                        ? () {
                            simulationSession.handSettings[index] =
                                PlayerHandRange();
                          }
                        : null,
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: StadiumBorder(),
                        color: handSetting is PlayerHandRange
                            ? Color(0x3f1dd1a1)
                            : Color(0x3fc8d6e5),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: Text(
                        "Range",
                        style: TextStyle(
                          fontFamily: "WorkSans",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                          color: handSetting is PlayerHandRange
                              ? Color(0xff10ac84)
                              : Color(0xff576574),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (handSetting is PlayerHoleCards) HoleCardSelect(index: index),
              if (handSetting is PlayerHandRange) RangeSelect(index: index),
            ],
          ),
        );
      },
    );
  }
}

class HoleCardSelect extends StatefulWidget {
  HoleCardSelect({this.index, Key key})
      : assert(index != null),
        super(key: key);

  final int index;

  @override
  _HoleCardSelectState createState() => _HoleCardSelectState();
}

class _HoleCardSelectState extends State<HoleCardSelect> {
  HoleCardSide selectedSideToChange = HoleCardSide.left;

  void _onCardSelectedToChange(HoleCardSide side) {
    setState(() {
      selectedSideToChange = side;
    });
  }

  void _onCardSelected(Card card) {
    final simulationSession = Provider.of<SimulationSession>(context);
    final handSetting = simulationSession.handSettings.elementAt(widget.index)
        as PlayerHoleCards;

    if (selectedSideToChange == HoleCardSide.left) {
      simulationSession.handSettings[widget.index] =
          handSetting.copyWith(left: card);

      setState(() {
        selectedSideToChange = HoleCardSide.right;
      });
    } else if (selectedSideToChange == HoleCardSide.right) {
      simulationSession.handSettings[widget.index] =
          handSetting.copyWith(right: card);

      setState(() {
        selectedSideToChange = HoleCardSide.left;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final handSetting = Provider.of<SimulationSession>(context)
        .handSettings
        .elementAt(widget.index) as PlayerHoleCards;

    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 128,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedSideToChange == HoleCardSide.left
                          ? Color(0x7ffeca57)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () {
                        _onCardSelectedToChange(HoleCardSide.left);
                      },
                      child: handSetting[0] == null
                          ? PlayingCardBack()
                          : PlayingCard(
                              card: handSetting[0],
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedSideToChange == HoleCardSide.right
                          ? Color(0x7ffeca57)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () {
                        _onCardSelectedToChange(HoleCardSide.right);
                      },
                      child: handSetting[1] == null
                          ? PlayingCardBack()
                          : PlayingCard(
                              card: handSetting[1],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Text(
            selectedSideToChange == null
                ? "Tap a card above to change"
                : "Select a card below to replace",
            style: TextStyle(
              color: Color(0xff000000),
              fontFamily: "WorkSans",
              fontSize: 16,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: CardSelector(
              unavailableCards: {},
              onTap: _onCardSelected,
            ),
          ),
        ],
      ),
    );
  }
}

enum HoleCardSide {
  left,
  right,
}

class RangeSelect extends StatefulWidget {
  RangeSelect({this.index, Key key})
      : assert(index != null),
        super(key: key);

  final int index;

  @override
  _RangeSelectState createState() => _RangeSelectState();
}

class _RangeSelectState extends State<RangeSelect> {
  @override
  Widget build(BuildContext context) {
    final simulationSession = Provider.of<SimulationSession>(context);
    final handSetting = simulationSession.handSettings.elementAt(widget.index)
        as PlayerHandRange;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: RangeSelectGrid(
        initial: handSetting.handRange,
        onUpdate: (handRange) {
          simulationSession.handSettings[widget.index] =
              handSetting.copyWith(handRange);
        },
      ),
    );
  }
}
