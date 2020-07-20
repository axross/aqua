import 'package:aqua/common_widgets/aqua_preferences.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/playing_card.dart';
import 'package:aqua/common_widgets/readonly_range_grid.dart';
import "package:aqua/constants/hand.dart";
import 'package:aqua/services/simulation_isolate_service.dart';
import 'package:aqua/utilities/number_format.dart';
import 'package:aqua/view_models/player_hand_setting.dart';
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

  final PlayerSimulationOverallResult result;

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
            child: playerHandSetting.holeCardPairs.first[0] != null
                ? PlayingCard(card: playerHandSetting.holeCardPairs.first[0])
                : PlayingCardBack(),
          ),
          SizedBox(width: 8),
          Expanded(
            child: playerHandSetting.holeCardPairs.first[1] != null
                ? PlayingCard(card: playerHandSetting.holeCardPairs.first[1])
                : PlayingCardBack(),
          ),
        ],
      );
    }

    if (playerHandSetting.type == PlayerHandSettingType.handRange) {
      return Column(
        children: [
          ReadonlyRangeGrid(handRange: playerHandSetting.handRange),
          SizedBox(height: 8),
          Text(
            "${formatOnlyWholeNumberPart(playerHandSetting.handRangeCardPairCombinations.length / 1326)}% combs",
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

  final PlayerSimulationOverallResult result;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MainValuePart(result: result),
        SizedBox(height: 8),
        Column(
          children: (result.winsByHandType.entries
                  .map((entry) => MapEntry(entry.key, entry.value))
                  .toList()
                    ..sort((a, b) => b.value - a.value))
              .take(3)
              .map((entry) => Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          "${formatOnlyWholeNumberPartWithPrefix(entry.value / result.games)}",
                          style: theme.digitTextStyle.copyWith(
                            color: theme.dimForegroundColor,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "% win at ${handTypeStrings[entry.key].toUpperCase()}",
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

class _MainValuePart extends StatelessWidget {
  _MainValuePart({@required this.result, Key key})
      : assert(result != null),
        super(key: key);

  final PlayerSimulationOverallResult result;

  @override
  Widget build(BuildContext context) {
    final preference = AquaPreferences.of(context);

    return AnimatedBuilder(
      animation: preference,
      builder: (context, child) => preference.preferEquity
          ? _EquityMainValuePart(result: result)
          : _WinRateMainValuePart(result: result),
    );
  }
}

class _EquityMainValuePart extends StatelessWidget {
  _EquityMainValuePart({@required this.result, Key key})
      : assert(result != null),
        super(key: key);

  final PlayerSimulationOverallResult result;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          "${formatOnlyWholeNumberPart(result.equity)}",
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
          "${formatOnlyFractionalPart(result.equity)}",
          style: theme.digitTextStyle.copyWith(
            color: theme.foregroundColor,
            fontSize: 18,
          ),
        ),
        Text(
          "% equity",
          style: theme.textStyle.copyWith(
            color: theme.foregroundColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _WinRateMainValuePart extends StatelessWidget {
  _WinRateMainValuePart({@required this.result, Key key})
      : assert(result != null),
        super(key: key);

  final PlayerSimulationOverallResult result;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              "${formatOnlyWholeNumberPart(result.winRate + result.tieRate)}",
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
              "${formatOnlyFractionalPart(result.winRate + result.tieRate)}",
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
              "${formatOnlyWholeNumberPartWithPrefix(result.tieRate)}",
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
