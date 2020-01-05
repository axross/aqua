import 'package:aqua/models/player_hand_setting.dart';
import 'package:meta/meta.dart';

@immutable
class PlayerHandSettingPreset {
  PlayerHandSettingPreset({@required this.name, @required this.parts})
      : assert(parts != null);

  final String name;

  final Set<PlayerHandSettingRangePart> parts;

  PlayerHandSetting toPlayerHandSetting() => PlayerHandSetting(parts: parts);
}
