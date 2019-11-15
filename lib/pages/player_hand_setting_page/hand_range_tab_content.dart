import 'dart:io';
import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/hand_range_select_grid.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HandRangeTabContent extends StatefulWidget {
  HandRangeTabContent({this.index, Key key})
      : assert(index != null),
        super(key: key);

  final int index;

  @override
  _HandRangeTabContentState createState() => _HandRangeTabContentState();
}

class _HandRangeTabContentState extends State<HandRangeTabContent> {
  int _previousHandRangeLengthTaken = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final simulationSession = Provider.of<SimulationSession>(context);
      final handSetting =
          simulationSession.playerHandSettings.value[widget.index];

      setState(() {
        _previousHandRangeLengthTaken = handSetting.cardPairCombinations.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final simulationSession = Provider.of<SimulationSession>(context);
    final handSetting =
        simulationSession.playerHandSettings.value[widget.index];
    final theme = AquaTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: HandRangeSelectGrid(
            value: handSetting.onlyHandRange,
            onUpdate: (handRange) {
              simulationSession.playerHandSettings.value = [
                ...simulationSession.playerHandSettings.value
              ]..[widget.index] = PlayerHandSetting(parts: handRange);

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
        SizedBox(height: 16),
        Material(
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
              value: handSetting.onlyHandRange.length.toDouble() /
                  handRangePartsInStrongnessOrder.length,
              label:
                  "${(handSetting.cardPairCombinations.length * 100 / 1326).round()}% Range",
              onChanged: (value) {
                final handRangeLengthTaken =
                    (value * handRangePartsInStrongnessOrder.length).round();

                if (handRangeLengthTaken != _previousHandRangeLengthTaken) {
                  if (Platform.isIOS) {
                    HapticFeedback.selectionClick();
                  }

                  final handRange = handRangePartsInStrongnessOrder
                      .take(handRangeLengthTaken);

                  setState(() {
                    _previousHandRangeLengthTaken = handRangeLengthTaken;

                    simulationSession.playerHandSettings.value = [
                      ...simulationSession.playerHandSettings.value
                    ]..[widget.index] =
                        PlayerHandSetting(parts: handRange.toSet());
                  });

                  Analytics.of(context).logEvent(
                    name: "update_player_hand_setting",
                    parameters: {
                      "type": "range",
                      "length": handRange.length,
                      "via": "slider",
                    },
                  );
                }
              },
              onChangeStart: (_) => HapticFeedback.lightImpact(),
            ),
          ),
        ),
      ],
    );
  }
}
