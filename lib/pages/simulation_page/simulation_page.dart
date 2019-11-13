import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/playing_card.dart';
import 'package:aqua/common_widgets/readonly_range_grid.dart';
import 'package:aqua/models/card.dart';
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
import 'package:flutter/services.dart';
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
      topColor: theme.dimBackgroundColor,
      bottomColor: theme.backgroundColor,
    );

    return ValueListenableBuilder(
      valueListenable: simulationSession.error,
      builder: (context, error, _) => Container(
        color: theme.backgroundColor,
        child: Column(
          children: [
            Container(
              color: theme.dimBackgroundColor,
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: 56,
                  child: Center(
                    child: ValueListenableBuilder<List<Card>>(
                      valueListenable: simulationSession.board,
                      builder: (context, board, _) => Text(
                        () {
                          switch (board.where((card) => card != null).length) {
                            case 0:
                              return "Odds at Preflop";
                            case 3:
                              return "Odds at Flop";
                            case 4:
                              return "Odds at Turn";
                            case 5:
                              return "Odds at River";
                            default:
                              return "Odds Calculation";
                          }
                        }(),
                        style: theme.appBarTextStyle,
                      ),
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
                          theme.dimForegroundColor,
                        ),
                  backgroundColor: Color(0x00000000),
                ),
              ),
            ),
            SizedBox(height: 10), // LinearProgressIndicator has 6 height
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();

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
                child: (() {
                  if (error is InsafficientHandSettingException) {
                    return Text(
                      "At least 2 players to calculate",
                      style: theme.textStyle
                          .copyWith(color: theme.dimForegroundColor),
                    );
                  }
                  if (error is InvalidBoardException) {
                    return Text(
                      "Set the board to be preflop, flop, turn or river to calculate",
                      style: theme.textStyle
                          .copyWith(color: theme.errorForegroundColor),
                    );
                  }

                  if (error is IncompleteHandSettingException) {
                    return Text(
                      "Swipe to delete empty player to calculate",
                      style: theme.textStyle
                          .copyWith(color: theme.errorForegroundColor),
                    );
                  }

                  if (error is NoPossibleCombinationException) {
                    return Text(
                      "No possible combination. Change any player's certain cards or range to calculate",
                      style: theme.textStyle
                          .copyWith(color: theme.errorForegroundColor),
                    );
                  }

                  throw AssertionError("unreachable here.");
                })(),
              ),
            Expanded(
              child: PlayerListView(),
            ),
          ],
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
              HapticFeedback.mediumImpact();

              simulationSession.playerHandSettings.value = [
                ...playerHandSetting
              ]..removeAt(index);

              Analytics.of(context).logEvent(
                name: "delete_player_hand_setting",
              );
            },
            background: Container(
              color: theme.errorBackgroundColor,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    "Delete".toUpperCase(),
                    style: theme.textStyle
                        .copyWith(color: theme.whiteForegroundColor),
                  ),
                ),
              ),
            ),
            secondaryBackground: Container(
              color: theme.errorBackgroundColor,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    "Delete".toUpperCase(),
                    style: theme.textStyle
                        .copyWith(color: theme.whiteForegroundColor),
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

    return ValueListenableBuilder<List<PlayerHandSetting>>(
      valueListenable: simulationSession.playerHandSettings,
      builder: (context, playerHandSettings, _) {
        final playerHandSetting = playerHandSettings[index];
        Widget leftItem;

        if (playerHandSetting.type == PlayerHandSettingType.holeCards) {
          leftItem = Row(
            children: [
              Expanded(
                child: playerHandSetting.onlyHoleCards.left != null
                    ? PlayingCard(card: playerHandSetting.onlyHoleCards.left)
                    : PlayingCardBack(),
              ),
              SizedBox(width: 8),
              Expanded(
                child: playerHandSetting.onlyHoleCards.right != null
                    ? PlayingCard(card: playerHandSetting.onlyHoleCards.right)
                    : PlayingCardBack(),
              ),
            ],
          );
        }

        if (playerHandSetting.type == PlayerHandSettingType.handRange) {
          leftItem = Column(
            children: [
              ReadonlyRangeGrid(
                handRange: playerHandSetting.onlyHandRange,
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
            HapticFeedback.lightImpact();

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
                width: 120,
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
                              entry.key, entry.value.win + entry.value.draw))
                          .toList()
                            ..sort((a, b) => b.value - a.value);
                      final top3HandTypes = sortedHandTypes.take(3);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    "${((result.winRate + result.drawRate) * 100).floor()}",
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
                                    "${_twoDigitFormat.format(((result.winRate + result.drawRate) * 10000 % 100).floor())}",
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    "${_format(result.drawRate * 100)}",
                                    style: theme.digitTextStyle.copyWith(
                                      color: theme.dimForegroundColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "% chop",
                                    style: theme.textStyle.copyWith(
                                      color: theme.dimForegroundColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
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
                                            "${_format(entry.value / result.totalGames * 100)}",
                                            style:
                                                theme.digitTextStyle.copyWith(
                                              color: theme.dimForegroundColor,
                                              fontSize: 18,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "% win at ${_handTypeStrings[entry.key].toUpperCase()}",
                                            style: theme.textStyle.copyWith(
                                              color: theme.dimForegroundColor,
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
        HapticFeedback.lightImpact();

        final simulationSession = Provider.of<SimulationSession>(context);
        final playerHandSettings = simulationSession.playerHandSettings.value;

        simulationSession.playerHandSettings.value = [
          ...playerHandSettings,
          PlayerHandSetting.emptyHoleCards(),
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
            width: 120,
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
                      size: 20, color: theme.dimForegroundColor),
                  SizedBox(width: 8),
                  Text("Tap here to add player",
                      style: theme.textStyle
                          .copyWith(color: theme.dimForegroundColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _format(double value) {
  if (value % 1 == 0) return "${value.floor()}";

  return "≈${value.round()}";
}

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
