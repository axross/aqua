import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/hand_range_select_grid.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PlayerHandRangeSelect extends StatefulWidget {
  PlayerHandRangeSelect({this.index, Key key})
      : assert(index != null),
        super(key: key);

  final int index;

  @override
  _PlayerHandRangeSelectState createState() => _PlayerHandRangeSelectState();
}

class _PlayerHandRangeSelectState extends State<PlayerHandRangeSelect> {
  @override
  Widget build(BuildContext context) {
    final simulationSession = Provider.of<SimulationSession>(context);
    final handSetting =
        simulationSession.playerHandSettings.value[widget.index];

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: HandRangeSelectGrid(
            initial: handSetting.onlyHandRange,
            onUpdate: (handRange) {
              simulationSession.playerHandSettings.value = [
                ...simulationSession.playerHandSettings.value
              ]..[widget.index] = PlayerHandSetting(parts: handRange);

              Analytics.of(context).logEvent(
                name: "update_player_hand_setting",
                parameters: {
                  "type": "range",
                  "length": handRange.length,
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
