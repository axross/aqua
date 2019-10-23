import 'package:aqua/models/player_hand_setting.dart';
import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart' show NumberFormat;
import 'package:provider/provider.dart';
import '../models/hand.dart' show HandType;
import '../models/simulation_result.dart' show SimulationResult;
import '../view_models/simulation_session.dart' show SimulationSession;
import './playing_card.dart' show PlayingCard, PlayingCardBack;
import './range_select_dialog_route.dart' show RangeSelectDialogRoute;
import './readonly_range_grid.dart' show ReadonlyRangeGrid;

class PlayerListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SimulationSession>(context);

    return AnimatedBuilder(
      animation: session.handSettings,
      builder: (context, _) => AnimatedBuilder(
        animation: session.results,
        builder: (context, _) => ListView.separated(
          padding: EdgeInsets.only(top: 16, bottom: 80),
          itemBuilder: (_, index) {
            return Dismissible(
              onDismissed: (_) {
                session.handSettings.removeAt(index);
              },
              background: Container(color: Color(0xffff6b6b)),
              child: PlayerListViewItem(
                index: index,
              ),
              key: ObjectKey(session.handSettings.elementAt(index)),
            );
          },
          separatorBuilder: (_, __) => SizedBox(height: 16),
          itemCount: session.handSettings.length,
        ),
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
    final simulationSession = Provider.of<SimulationSession>(context);
    final handSetting = simulationSession.handSettings[index];
    final result = simulationSession.results[index] as SimulationResult;
    Widget leftItem;

    if (handSetting is PlayerHoleCards) {
      leftItem = Row(
        children: [
          Expanded(
            child: handSetting[0] == null
                ? PlayingCardBack()
                : PlayingCard(
                    card: handSetting[0],
                  ),
          ),
          SizedBox(width: 4),
          Expanded(
            child: handSetting[1] == null
                ? PlayingCardBack()
                : PlayingCard(
                    card: handSetting[1],
                  ),
          ),
        ],
      );
    }

    if (handSetting is PlayerHandRange) {
      leftItem = ReadonlyRangeGrid(
        handRange: handSetting.handRange,
      );
    }

    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(RangeSelectDialogRoute(
                        simulationSession: simulationSession,
                        index: index,
                      ));
                    },
                    child: leftItem,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            result != null
                                ? "${(result.winRate * 100).floor()}"
                                : "??",
                            style: TextStyle(
                              fontSize: 36,
                              color: Color(0xff222f3e),
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            result != null
                                ? ".${(result.winRate * 10000 % 100).floor()}% win"
                                : ".??% win",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff576574),
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${handSetting.cardPairCombinations.length} combinations",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff54a0ff),
                          fontFamily: "Rubik",
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      if (result != null)
                        SizedBox(height: 8),
                      if (result != null)
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          spacing: 8,
                          runSpacing: 8,
                          children: result.entries
                              .map((entry) => Column(
                                    children: [
                                      Image.asset(
                                        _handTypeAssetNames[entry.key],
                                        width: 72,
                                      ),
                                      Text(
                                        "${(result.totalGames == 0 ? 0 : (entry.value.win + entry.value.even) / result.totalGames * 100).toStringAsFixed(2)}% win",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff8395a7),
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      // Table(
                      //   columnWidths: {
                      //     0: IntrinsicColumnWidth(),
                      //     1: FlexColumnWidth(),
                      //   },
                      //   children: result.entries
                      //       .map((entry) => TableRow(
                      //             children: [
                      //               TableCell(
                      //                 child: Text(
                      //                   "${(result.totalGames == 0 ? 0 : (entry.value.win + entry.value.even) / result.totalGames * 100).toStringAsFixed(2)}% win ",
                      //                   style: TextStyle(
                      //                     fontSize: 14,
                      //                     color: Color(0xff8395a7),
                      //                     fontFamily: "Rubik",
                      //                     fontWeight: FontWeight.w400,
                      //                     decoration: TextDecoration.none,
                      //                   ),
                      //                 ),
                      //               ),
                      //               TableCell(
                      //                 child: Text(
                      //                   "at ${_handTypeStrings[entry.key]}",
                      //                   style: TextStyle(
                      //                     fontSize: 14,
                      //                     color: Color(0xff8395a7),
                      //                     fontFamily: "Rubik",
                      //                     fontWeight: FontWeight.w400,
                      //                     decoration: TextDecoration.none,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ))
                      //       .toList(),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _handTypeStrings = {
  HandType.straightFlush: "Straight Flush",
  HandType.fourOfAKind: "Four of a Kind",
  HandType.fullhouse: "Fullhouse",
  HandType.flush: "Flush",
  HandType.straight: "Straight",
  HandType.threeOfAKind: "Three of a Kind",
  HandType.twoPairs: "Two Pairs",
  HandType.aPair: "Pair",
  HandType.high: "High",
};

const _handTypeAssetNames = {
  HandType.straightFlush: "assets/images/straight-flush.png",
  HandType.fourOfAKind: "assets/images/four-of-a-kind.png",
  HandType.fullhouse: "assets/images/fullhouse.png",
  HandType.flush: "assets/images/flush.png",
  HandType.straight: "assets/images/straight.png",
  HandType.threeOfAKind: "assets/images/three-of-a-kind.png",
  HandType.twoPairs: "assets/images/two-pairs.png",
  HandType.aPair: "assets/images/pair.png",
  HandType.high: "assets/images/high.png",
};
