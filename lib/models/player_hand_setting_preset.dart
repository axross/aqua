import 'package:aqua/models/player_hand_setting.dart';
import 'package:meta/meta.dart';

class PlayerHandSettingPreset {
  PlayerHandSettingPreset({@required this.name, @required this.parts})
      : assert(name != null),
        assert(parts != null);

  final String name;

  final Set<PlayerHandSettingRangePart> parts;

  PlayerHandSetting toPlayerHandSetting() => PlayerHandSetting(parts: parts);
}
