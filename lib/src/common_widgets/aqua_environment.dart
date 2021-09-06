import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";

class AquaEnvironment extends InheritedWidget {
  AquaEnvironment({
    Key? key,
    required Widget child,
  })  : data = AquaEnvironmentData(),
        super(key: key, child: child);

  final AquaEnvironmentData data;

  @override
  bool updateShouldNotify(AquaEnvironment old) => data != old.data;

  static AquaEnvironmentData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AquaEnvironment>()!.data;
}

@immutable
class AquaEnvironmentData {
  final isDebugBuild = kDebugMode;
}
