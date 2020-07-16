import 'package:aqua/view_models/player_hand_setting.dart';
import 'package:meta/meta.dart';
import 'package:poker/poker.dart';

@immutable
class PlayerHandSettingPreset {
  PlayerHandSettingPreset({
    @required this.name,
    @required this.type,
    this.holeCardPairs = const [NullableCardPair(null, null)],
    this.handRange = const {},
  })  : assert(name != null),
        assert(type != null);

  final String name;

  final PlayerHandSettingType type;

  final List<NullableCardPair> holeCardPairs;

  final Set<HandRangePart> handRange;

  PlayerHandSetting toPlayerHandSetting() => PlayerHandSetting(
        type: type,
        holeCardPairs: [...holeCardPairs],
        handRange: {...handRange},
      );
}
