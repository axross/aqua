import "package:aqua/src/common_widgets/simulation_session.dart";
import "package:aqua/src/models/nullable_card_pair.dart";
import "package:meta/meta.dart";
import "package:poker/poker.dart";

@immutable
class PlayerHandSettingPreset {
  const PlayerHandSettingPreset({
    @required this.name,
    @required this.type,
    this.holeCardPairs = const [NullableCardPair.empty()],
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
