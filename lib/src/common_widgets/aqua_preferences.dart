import "package:aqua/src/view_models/aqua_preference_data.dart";
import "package:flutter/widgets.dart";

class AquaPreferences extends InheritedWidget {
  AquaPreferences({
    @required this.data,
    Widget child,
    Key key,
  })  : assert(data != null),
        super(key: key, child: child);

  final AquaPreferenceData data;

  @override
  bool updateShouldNotify(AquaPreferences old) => data != old.data;

  static AquaPreferenceData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AquaPreferences>().data;
}
