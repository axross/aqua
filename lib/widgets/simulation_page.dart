import 'package:aqua/models/hand_type.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/simulation_result.dart';
import 'package:aqua/models/simulator.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:aqua/widgets/aqua_theme.dart';
import 'package:aqua/widgets/board_select_dialog_route.dart';
import 'package:aqua/widgets/player_hand_setting_dialog_route.dart';
import 'package:aqua/widgets/playing_card.dart';
import 'package:aqua/widgets/readonly_range_grid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SimulationPage extends StatefulWidget {
  SimulationPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  ValueNotifier<SimulationSession> _simulationSession;

  @override
  void initState() {
    super.initState();

    _simulationSession = ValueNotifier(SimulationSession.initial());
  }

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return ValueListenableBuilder<SimulationSession>(
      valueListenable: _simulationSession,
      builder: (context, simulationSession, __) => Provider.value(
        value: simulationSession,
        child: ValueListenableBuilder(
          valueListenable: simulationSession.playerHandSettings,
          builder: (context, playerHandSettings, _) => ValueListenableBuilder(
            valueListenable: simulationSession.error,
            builder: (context, error, _) => Scaffold(
              backgroundColor: theme.backgroundColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: theme.appBarBackgroundColor,
                brightness: Brightness.light,
                title: Text(
                  "Aqua",
                  style: theme.appBarTextStyle
                      .copyWith(color: theme.foregroundColor),
                ),
              ),
              body: Column(
                children: [
                  SizedBox(height: 32),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).push(BoardSelectDialogRoute(
                      simulationSession: simulationSession,
                    )),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ValueListenableBuilder(
                        valueListenable: simulationSession.board,
                        builder: (context, board, _) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(9, (i) {
                            if (i % 2 == 1) return SizedBox(width: 8);

                            final index = i ~/ 2;

                            return SizedBox(
                                width: 56,
                                child: board[index] != null
                                    ? PlayingCard(card: board[index])
                                    : PlayingCardBack());
                          }),
                        ),
                      ),
                    ),
                  ),
                  if (error != null)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      child: Text(
                        getMessageBySimulationCencelException(error),
                        style: theme.textStyle
                            .copyWith(color: theme.errorForegroundColor),
                      ),
                    ),
                  Expanded(
                    child: PlayerListView(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final simulationSession = Provider.of<SimulationSession>(context);

    return ValueListenableBuilder(
      valueListenable: simulationSession.playerHandSettings,
      builder: (context, playerHandSetting, _) => ListView.builder(
        padding: EdgeInsets.only(bottom: 80),
        itemBuilder: (_, index) {
          if (index == playerHandSetting.length) {
            return PlayerListViewNewItem();
          }

          return Dismissible(
            onDismissed: (_) {
              simulationSession.playerHandSettings.value = [
                ...playerHandSetting
              ]..removeAt(index);
            },
            background: Container(color: Color(0xffff6b6b)),
            child: PlayerListViewItem(index: index),
            key: ObjectKey(playerHandSetting[index]),
          );
        },
        itemCount: playerHandSetting.length + 1,
      ),
    );
  }
}

class PlayerListViewItem extends StatelessWidget {
  PlayerListViewItem({this.index, Key key})
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
        Widget leftItem;

        if (playerHandSetting is PlayerHoleCards) {
          leftItem = Row(
            children: List.generate(
              3,
              (i) {
                final index = i ~/ 2;

                return i % 2 == 0
                    ? Expanded(
                        child: playerHandSetting[index] != null
                            ? PlayingCard(card: playerHandSetting[index])
                            : PlayingCardBack(),
                      )
                    : SizedBox(width: 8);
              },
            ),
          );
        }

        if (playerHandSetting is PlayerHandRange) {
          leftItem = Column(
            children: [
              ReadonlyRangeGrid(
                handRange: playerHandSetting.handRange,
              ),
              SizedBox(height: 8),
              Text(
                "${playerHandSetting.cardPairCombinations.length} combs",
                style: theme.textStyle.copyWith(
                  color: theme.secondaryBackgroundColor,
                  fontSize: 14,
                ),
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 136,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).push(PlayerHandSettingDialogRoute(
                    simulationSession: simulationSession,
                    index: index,
                  ));
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: leftItem,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16, right: 16),
                child: ValueListenableBuilder<List<SimulationResult>>(
                  valueListenable: simulationSession.results,
                  builder: (context, results, _) {
                    final result =
                        index < results.length ? results[index] : null;

                    if (result == null) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "??",
                            style: theme.textStyle.copyWith(
                              color: theme.secondaryBackgroundColor,
                              fontSize: 32,
                            ),
                          ),
                          Text(
                            ".??% win",
                            style: theme.textStyle.copyWith(
                              color: theme.secondaryBackgroundColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    }

                    final sortedHandTypes = result.entries
                        .map((entry) => MapEntry(
                            entry.key, entry.value.win + entry.value.even))
                        .toList()
                          ..sort((a, b) => b.value - a.value);
                    final top3HandTypes = sortedHandTypes.take(3);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "${_twoDigitFormat.format(result.winRate * 100)}",
                              style: theme.digitTextStyle.copyWith(
                                color: theme.foregroundColor,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              ".",
                              style: theme.textStyle.copyWith(
                                color: theme.foregroundColor,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              "${_twoDigitFormat.format(result.winRate * 10000 % 100)}",
                              style: theme.digitTextStyle.copyWith(
                                color: theme.foregroundColor,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "% win",
                              style: theme.textStyle.copyWith(
                                color: theme.foregroundColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Column(
                          children: top3HandTypes
                              .map((entry) => Row(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          "${_numberFormat.format(entry.value / result.totalGames * 100)}",
                                          style: theme.digitTextStyle.copyWith(
                                            color:
                                                theme.secondaryBackgroundColor,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "% win at ${_handTypeStrings[entry.key].toUpperCase()}",
                                          style: theme.textStyle.copyWith(
                                            color:
                                                theme.secondaryBackgroundColor,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PlayerListViewNewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final simulationSession = Provider.of<SimulationSession>(context);
        final playerHandSettings = simulationSession.playerHandSettings.value;

        simulationSession.playerHandSettings.value = [
          ...playerHandSettings,
          PlayerHoleCards(),
        ];

        Navigator.of(context).push(PlayerHandSettingDialogRoute(
          simulationSession: simulationSession,
          index: playerHandSettings.length,
        ));
      },
      child: Row(
        children: [
          SizedBox(
            width: 136,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: PlayingCardBack(),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: PlayingCardBack(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(Feather.getIconData("plus-circle"),
                      size: 20, color: theme.secondaryBackgroundColor),
                  SizedBox(width: 8),
                  Text("Tap here to add player",
                      style: theme.textStyle
                          .copyWith(color: theme.secondaryBackgroundColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final _numberFormat = NumberFormat("#0");

final _twoDigitFormat = NumberFormat("00");

final _handTypeStrings = {
  HandType.straightFlush: "Str. Flush",
  HandType.fourOfAKind: "Four of a Kind",
  HandType.fullHouse: "Fullhouse",
  HandType.flush: "Flush",
  HandType.straight: "Straight",
  HandType.threeOfAKind: "Three of a Kind",
  HandType.twoPairs: "TWo Pairs",
  HandType.pair: "Pair",
  HandType.high: "High",
};

String getMessageBySimulationCencelException(
    SimulationCancelException exception) {
  if (exception is InsafficientHandSettingException)
    return "Add more players to calculate";
  if (exception is InvalidBoardException)
    return "Set the board to be preflop, flop, turn or river to calculate";
  if (exception is IncompleteHandSettingException)
    return "Swipe to delete empty player to calculate";
  if (exception is NoPossibleCombinationException)
    return "No possible combination. Change any player's certain cards or range to calculate";

  assert(false, "unreachable here.");
}
