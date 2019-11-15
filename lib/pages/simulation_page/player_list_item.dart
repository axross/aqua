import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/playing_card.dart';
import 'package:aqua/common_widgets/readonly_range_grid.dart';
import 'package:aqua/models/card_pair.dart';
import 'package:aqua/models/hand_type.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/simulation_result.dart';
import 'package:aqua/utilities/number_format.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PlayerListItem extends StatelessWidget {
  PlayerListItem({
    @required this.playerHandSetting,
    this.result,
    @required this.onPressed,
    this.onDismissed,
    @required this.key,
  })  : assert(playerHandSetting != null),
        assert(onPressed != null),
        assert(key != null),
        super(key: key);

  final PlayerHandSetting playerHandSetting;

  final SimulationResult result;

  final void Function() onPressed;

  final void Function() onDismissed;

  final Key key;

  @override
  Widget build(BuildContext context) => Dismissible(
        onDismissed: (_) {
          HapticFeedback.heavyImpact();

          onDismissed();
        },
        background: _DismissibleBackground(),
        secondaryBackground: _DismissibleBackground(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            HapticFeedback.lightImpact();

            onPressed();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: _LeftItem(playerHandSetting: playerHandSetting),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16, right: 16),
                  child: result == null
                      ? _RightEmptyItem()
                      : _RightItem(result: result),
                ),
              ),
            ],
          ),
        ),
        key: key,
      );
}

class _DismissibleBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Container(
      color: theme.errorBackgroundColor,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Delete".toUpperCase(),
            style: theme.textStyle.copyWith(color: theme.whiteForegroundColor),
          ),
        ),
      ),
    );
  }
}

class _LeftItem extends StatelessWidget {
  _LeftItem({
    @required this.playerHandSetting,
    Key key,
  }) : super(key: key);

  final PlayerHandSetting playerHandSetting;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    if (playerHandSetting.type == PlayerHandSettingType.holeCards) {
      return Row(
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
      return Column(
        children: [
          ReadonlyRangeGrid(
            handRange: playerHandSetting.onlyHandRange,
          ),
          SizedBox(height: 8),
          Text(
            "${formatOnlyWholeNumberPart(playerHandSetting.cardPairCombinations.length / numberOfAllHoleCardCombinations)}% combs",
            style: theme.textStyle.copyWith(
              color: theme.secondaryBackgroundColor,
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    throw AssertionError("unreachable here.");
  }
}

class _RightItem extends StatelessWidget {
  _RightItem({@required this.result, Key key})
      : assert(result != null),
        super(key: key);

  final SimulationResult result;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final winOrDrawRate = result.winRate + result.drawRate;

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
                  "${formatOnlyWholeNumberPart(winOrDrawRate)}",
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
                  "${formatOnlyFractionalPart(winOrDrawRate)}",
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
                  "${formatOnlyWholeNumberPartWithPrefix(result.drawRate)}",
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
          children: (result.entries
                  .map((entry) =>
                      MapEntry(entry.key, entry.value.win + entry.value.draw))
                  .toList()
                    ..sort((a, b) => b.value - a.value))
              .take(3)
              .map((entry) => Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          "${formatOnlyWholeNumberPartWithPrefix(entry.value / result.totalGames)}",
                          style: theme.digitTextStyle.copyWith(
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
  }
}

class _RightEmptyItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

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
}

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
