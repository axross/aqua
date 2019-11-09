import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/playing_card.dart';
import 'package:aqua/common_widgets/readonly_range_grid.dart';
import 'package:aqua/models/hand_type.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/simulation_result.dart';
import 'package:aqua/models/simulator.dart';
import 'package:aqua/popup_routes/board_setting_dialog_route%20copy.dart';
import 'package:aqua/popup_routes/player_hand_setting_dialog_route.dart';
import 'package:aqua/utilities/system_ui_overlay_style.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SimulationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final simulationSession = Provider.of<SimulationSession>(context);

    setSystemUIOverlayStyle(
      topColor: theme.appBarBackgroundColor,
      bottomColor: theme.backgroundColor,
    );

    return ValueListenableBuilder(
      valueListenable: simulationSession.playerHandSettings,
      builder: (context, playerHandSettings, _) => ValueListenableBuilder(
        valueListenable: simulationSession.error,
        builder: (context, error, _) => Container(
          color: theme.backgroundColor,
          child: Column(
            children: [
              Container(
                color: theme.appBarBackgroundColor,
                child: SafeArea(
                  child: Container(
                    height: 56,
                    child: Center(
                      child: Text(
                        "Calculate",
                        style: theme.appBarTextStyle
                            .copyWith(color: theme.appBarForegroundColor),
                      ),
                    ),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(height: 2),
                child: ValueListenableBuilder(
                  valueListenable: simulationSession.progress,
                  builder: (context, progress, _) => LinearProgressIndicator(
                    value: progress,
                    valueColor: progress == 1.0
                        ? AlwaysStoppedAnimation<Color>(Color(0x00000000))
                        : AlwaysStoppedAnimation<Color>(
                            theme.secondaryBackgroundColor,
                          ),
                    backgroundColor: Color(0x00000000),
                  ),
                ),
              ),
              SizedBox(height: 10), // LinearProgressIndicator has 6 height
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(BoardSettingDialogRoute());

                  Analytics.of(context).logEvent(
                    name: "open_board_select_dialog",
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ValueListenableBuilder(
                    valueListenable: simulationSession.board,
                    builder: (context, board, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          child: board[0] != null
                              ? PlayingCard(card: board[0])
                              : PlayingCardBack(),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 56,
                          child: board[1] != null
                              ? PlayingCard(card: board[1])
                              : PlayingCardBack(),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 56,
                          child: board[2] != null
                              ? PlayingCard(card: board[2])
                              : PlayingCardBack(),
                        ),
                        SizedBox(width: 16),
                        SizedBox(
                          width: 56,
                          child: board[3] != null
                              ? PlayingCard(card: board[3])
                              : PlayingCardBack(),
                        ),
                        SizedBox(width: 16),
                        SizedBox(
                          width: 56,
                          child: board[4] != null
                              ? PlayingCard(card: board[4])
                              : PlayingCardBack(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (error != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
    );
  }
}

class PlayerListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
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

              Analytics.of(context).logEvent(
                name: "delete_player_hand_setting",
              );
            },
            background: Container(
              color: Color(0xffff6b6b),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    "Delete".toUpperCase(),
                    style: theme.textStyle.copyWith(color: Color(0xffffffff)),
                  ),
                ),
              ),
            ),
            secondaryBackground: Container(
              color: Color(0xffff6b6b),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    "Delete".toUpperCase(),
                    style: theme.textStyle.copyWith(color: Color(0xffffffff)),
                  ),
                ),
              ),
            ),
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

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).push(PlayerHandSettingDialogRoute(
              settings: RouteSettings(
                arguments: {"index": index},
              ),
            ));

            Analytics.of(context).logEvent(
              name: "open_player_hand_setting_dialog",
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 136,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: leftItem,
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
                                "${(result.winRate * 100).floor()}",
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
                                "${_twoDigitFormat.format((result.winRate * 10000 % 100).floor())}",
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
                                            "${_numberFormat.format((entry.value / result.totalGames * 100).floor())}",
                                            style:
                                                theme.digitTextStyle.copyWith(
                                              color: theme
                                                  .secondaryForegroundColor,
                                              fontSize: 18,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "% win at ${_handTypeStrings[entry.key].toUpperCase()}",
                                            style: theme.textStyle.copyWith(
                                              color: theme
                                                  .secondaryForegroundColor,
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
          ),
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
          settings: RouteSettings(
            arguments: {"index": playerHandSettings.length},
          ),
        ));

        Analytics.of(context).logEvent(
          name: "add_player_hand_setting",
        );
        Analytics.of(context).logEvent(
          name: "open_player_hand_setting_dialog",
        );
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

final _twoDigitFormat = NumberFormat("#00");

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

  return "";
}
