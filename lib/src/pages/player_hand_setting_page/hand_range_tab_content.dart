import 'dart:io' show Platform;
import 'package:aqua/src/common_widgets/aqua_theme.dart';
import 'package:aqua/src/common_widgets/hand_range_select_grid.dart';
import "package:aqua/src/constants/hand_range.dart";
import 'package:aqua/src/utilities/number_format.dart';
import 'package:aqua/src/view_models/player_hand_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:poker/poker.dart';

class HandRangeTabContent extends StatelessWidget {
  HandRangeTabContent({
    @required this.playerHandSetting,
    @required this.onChanged,
    Key key,
  })  : assert(playerHandSetting != null),
        assert(onChanged != null),
        super(key: key);

  final PlayerHandSetting playerHandSetting;

  final void Function(Set<HandRangePart>, {@required String via}) onChanged;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: HandRangeSelectGrid(
              value: playerHandSetting.handRange,
              onUpdate: (handRange) => onChanged(handRange, via: "grid"),
            ),
          ),
          SizedBox(height: 16),
          _HandRangeSlider(
            playerHandSetting: playerHandSetting,
            onSliderChanged: (handRange) => onChanged(handRange, via: "slider"),
          ),
        ],
      );
}

class _HandRangeSlider extends StatefulWidget {
  _HandRangeSlider({
    @required this.playerHandSetting,
    @required this.onSliderChanged,
    Key key,
  })  : assert(playerHandSetting != null),
        assert(onSliderChanged != null),
        super(key: key);

  final PlayerHandSetting playerHandSetting;

  final void Function(Set<HandRangePart>) onSliderChanged;

  @override
  State<_HandRangeSlider> createState() => _HandRangeSliderState();
}

class _HandRangeSliderState extends State<_HandRangeSlider> {
  int _previousHandRangeLengthTaken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_previousHandRangeLengthTaken == null) {
      _previousHandRangeLengthTaken =
          widget.playerHandSetting.handRangeComponents.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Material(
      color: Color(0x00000000),
      child: SliderTheme(
        data: SliderThemeData(
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
          thumbColor: theme.foregroundColor,
          activeTrackColor: theme.foregroundColor,
          inactiveTrackColor: theme.dimForegroundColor,
          valueIndicatorColor: theme.foregroundColor,
          valueIndicatorTextStyle: theme.textStyle
              .copyWith(color: theme.backgroundColor, fontSize: 12),
          overlayColor: Color(0x00000000),
        ),
        child: Slider(
          divisions: handRangeComponentsInStrongnessOrder.length,
          value:
              widget.playerHandSetting.handRangeComponents.length.toDouble() /
                  handRangeComponentsInStrongnessOrder.length,
          label:
              "${formatOnlyWholeNumberPart(widget.playerHandSetting.handRangeCardPairCombinations.length / 1326)}% combs",
          onChanged: (value) {
            final handRangeLengthTaken =
                (value * handRangeComponentsInStrongnessOrder.length).round();

            if (handRangeLengthTaken == _previousHandRangeLengthTaken) return;

            if (Platform.isIOS) {
              HapticFeedback.selectionClick();
            }

            setState(() {
              _previousHandRangeLengthTaken = handRangeLengthTaken;
            });

            widget.onSliderChanged(handRangeComponentsInStrongnessOrder
                .take(handRangeLengthTaken)
                .toSet());
          },
          onChangeStart: (_) => HapticFeedback.lightImpact(),
        ),
      ),
    );
  }
}
