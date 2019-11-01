import 'package:aqua/models/card.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/utilities/system_ui_overlay_style.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:aqua/widgets/analytics.dart';
import 'package:aqua/widgets/aqua_theme.dart';
import 'package:aqua/widgets/card_picker.dart';
import 'package:aqua/widgets/playing_card.dart';
import 'package:aqua/widgets/range_select_grid.dart';
import "package:flutter/widgets.dart";
import 'package:provider/provider.dart';

class PlayerHandSettingDialogRoute<T> extends PopupRoute<T> {
  PlayerHandSettingDialogRoute({
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
  ) =>
      Provider.value(
        value: simulationSession,
        child: PlayerHandSettingDialogPage(index: index),
      );
}

class PlayerHandSettingDialogPage extends StatelessWidget {
  PlayerHandSettingDialogPage({@required this.index, Key key})
      : assert(index != null),
        super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final simulationSession = Provider.of<SimulationSession>(context);

    return ValueListenableBuilder(
      valueListenable: simulationSession.playerHandSettings,
      builder: (context, playerHandSettings, _) {
        final playerHandSetting = playerHandSettings[index];

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
                HandSettingTypeSelector(index: index),
                SizedBox(height: 32),
                if (playerHandSetting is PlayerHoleCards)
                  HoleCardSelect(index: index),
                if (playerHandSetting is PlayerHandRange)
                  RangeSelect(index: index),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HandSettingTypeSelector extends StatelessWidget {
  HandSettingTypeSelector({@required this.index, Key key})
      : assert(index != null),
        super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final simulationSession = Provider.of<SimulationSession>(context);

    return ValueListenableBuilder(
      valueListenable: simulationSession.playerHandSettings,
      builder: (context, playerHandSettings, _) {
        final playerHandSetting = playerHandSettings[index];

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (playerHandSetting is PlayerHoleCards) return;

                simulationSession.playerHandSettings.value = [
                  ...playerHandSettings
                ]..[index] = PlayerHoleCards();

                Analytics.of(context).logEvent(
                  name: "update_player_hand_setting_type",
                  parameters: {"to": "hole_cards"},
                );
              },
              child: Container(
                decoration: ShapeDecoration(
                  shape: StadiumBorder(),
                  color: playerHandSetting is PlayerHoleCards
                      ? Color(0xff54a0ff)
                      : Color(0x3f54a0ff),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Text(
                  "Certain Cards",
                  style: theme.textStyle.copyWith(
                      color: playerHandSetting is PlayerHoleCards
                          ? Color(0xffffffff)
                          : Color(0xff54a0ff)),
                ),
              ),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                if (playerHandSetting is PlayerHandRange) return;

                simulationSession.playerHandSettings.value = [
                  ...playerHandSettings
                ]..[index] = PlayerHandRange.empty();

                Analytics.of(context).logEvent(
                  name: "update_player_hand_setting_type",
                  parameters: {"to": "range"},
                );
              },
              child: Container(
                decoration: ShapeDecoration(
                  shape: StadiumBorder(),
                  color: playerHandSetting is PlayerHandRange
                      ? Color(0xff1dd1a1)
                      : Color(0x3f1dd1a1),
                ),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Text(
                  "Range",
                  style: theme.textStyle.copyWith(
                      color: playerHandSetting is PlayerHandRange
                          ? Color(0xffffffff)
                          : Color(0xff1dd1a1)),
                ),
              ),
            ),
          ],
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
    final handSetting = simulationSession.playerHandSettings.value[widget.index]
        as PlayerHandRange;

    return RangeSelectGrid(
      initial: handSetting.handRange,
      onUpdate: (handRange) {
        simulationSession.playerHandSettings.value = [
          ...simulationSession.playerHandSettings.value
        ]..[widget.index] = handSetting.copyWith(handRange);

        Analytics.of(context).logEvent(
          name: "update_player_hand_setting",
          parameters: {
            "type": "range",
            "length": handRange.length,
          },
        );
      },
    );
  }
}
