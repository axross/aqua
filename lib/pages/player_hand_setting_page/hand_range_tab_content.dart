import 'dart:io' show Platform;
import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/hand_range_select_grid.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HandRangeTabContent extends StatelessWidget {
  HandRangeTabContent({this.index, Key key})
      : assert(index != null),
        super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final simulationSession = Provider.of<SimulationSession>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ValueListenableBuilder<List<PlayerHandSetting>>(
            valueListenable: simulationSession.playerHandSettings,
            builder: (context, playerHandSettings, _) => HandRangeSelectGrid(
              value: playerHandSettings[index].onlyHandRange,
              onUpdate: (handRange) {
                simulationSession.playerHandSettings.value = [
                  ...simulationSession.playerHandSettings.value
                ]..[index] = PlayerHandSetting(parts: handRange);

                Analytics.of(context).logEvent(
                  name: "update_player_hand_setting",
                  parameters: {
                    "type": "range",
                    "length": handRange.length,
                    "via": "grid",
                  },
                );
              },
            ),
          ),
        ),
        SizedBox(height: 16),
        _HandRangeSlider(index: index),
      ],
    );
  }
}

class _HandRangeSlider extends StatefulWidget {
  _HandRangeSlider({@required this.index, Key key})
      : assert(index != null),
        super(key: key);

  final int index;

  @override
  State<_HandRangeSlider> createState() => _HandRangeSliderState();
}

class _HandRangeSliderState extends State<_HandRangeSlider> {
  int _previousHandRangeLengthTaken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_previousHandRangeLengthTaken == null) {
      final simulationSession = Provider.of<SimulationSession>(context);
      final handSetting =
          simulationSession.playerHandSettings.value[widget.index];

      setState(() {
        _previousHandRangeLengthTaken = handSetting.cardPairCombinations.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final simulationSession = Provider.of<SimulationSession>(context);
    final theme = AquaTheme.of(context);

    return ValueListenableBuilder<List<PlayerHandSetting>>(
      valueListenable: simulationSession.playerHandSettings,
      builder: (context, playerHandSettings, _) => Material(
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
            divisions: handRangePartsInStrongnessOrder.length,
            value: playerHandSettings[widget.index]
                    .onlyHandRange
                    .length
                    .toDouble() /
                handRangePartsInStrongnessOrder.length,
            label:
                "${(playerHandSettings[widget.index].cardPairCombinations.length * 100 / 1326).round()}% Range",
            onChanged: (value) {
              final handRangeLengthTaken =
                  (value * handRangePartsInStrongnessOrder.length).round();

              if (handRangeLengthTaken == _previousHandRangeLengthTaken) return;

              if (Platform.isIOS) {
                HapticFeedback.selectionClick();
              }

              final handRange =
                  handRangePartsInStrongnessOrder.take(handRangeLengthTaken);

              setState(() {
                _previousHandRangeLengthTaken = handRangeLengthTaken;
              });

              simulationSession.playerHandSettings.value = [
                ...simulationSession.playerHandSettings.value
              ]..[widget.index] = PlayerHandSetting(parts: handRange.toSet());

              Analytics.of(context).logEvent(
                name: "update_player_hand_setting",
                parameters: {
                  "type": "range",
                  "length": handRange.length,
                  "via": "slider",
                },
              );
            },
            onChangeStart: (_) => HapticFeedback.lightImpact(),
          ),
        ),
      ),
    );
  }
}
