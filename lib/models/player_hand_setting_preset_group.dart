import 'package:aqua/models/player_hand_setting_preset.dart';
import 'package:meta/meta.dart';

@immutable
class PlayerHandSettingPresetGroup {
  PlayerHandSettingPresetGroup({
    @required this.name,
    @required this.presets,
  }) : assert(presets != null);

  final String name;

  final List<PlayerHandSettingPreset> presets;
}
