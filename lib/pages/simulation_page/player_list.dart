import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/simulation_result.dart';
import 'package:flutter/widgets.dart';
import './player_list_item.dart';
import './player_list_new_item.dart';

class PlayerList extends StatelessWidget {
  PlayerList({
    @required this.playerHandSettings,
    @required this.results,
    @required this.onItemPressed,
    @required this.onItemDismissed,
    @required this.onNewItemPressed,
    Key key,
  })  : assert(playerHandSettings != null),
        assert(results != null),
        assert(onItemPressed != null),
        assert(onItemDismissed != null),
        assert(onNewItemPressed != null),
        super(key: key);

  final List<PlayerHandSetting> playerHandSettings;

  final List<SimulationResult> results;

  final void Function(int) onItemPressed;

  final void Function(int) onItemDismissed;

  final void Function() onNewItemPressed;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ...List.generate(
              playerHandSettings.length,
              (index) => PlayerListItem(
                    playerHandSetting: playerHandSettings[index],
                    result: results.length > index ? results[index] : null,
                    onPressed: () => onItemPressed(index),
                    onDismissed: () => onItemDismissed(index),
                    key: ObjectKey(playerHandSettings[index]),
                  )),
          if (playerHandSettings.length < 10)
            PlayerListNewItem(
              onPressed: onNewItemPressed,
            ),
        ],
      );
}
