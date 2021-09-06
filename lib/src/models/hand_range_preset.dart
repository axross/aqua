import "package:meta/meta.dart";
import "package:poker/poker.dart";

@immutable
class HandRangePreset {
  const HandRangePreset({
    required this.name,
    required this.handRange,
  });

  final String name;

  final HandRange handRange;
}
