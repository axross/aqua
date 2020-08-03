import "package:flutter/widgets.dart";
import "package:shared_preferences/shared_preferences.dart";

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

class AquaPreferenceData extends ChangeNotifier {
  AquaPreferenceData();

  SharedPreferences preferences;

  bool _isLoaded = false;

  get isLoaded => _isLoaded;

  bool _prefersWinRate;

  bool get prefersWinRate => _prefersWinRate;

  Future<void> setPreferWinRate(bool value) async {
    _prefersWinRate = value;

    notifyListeners();

    await preferences.setBool("prefersWinRate", value);
  }

  Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();

    if (!preferences.containsKey("prefersWinRate")) {
      await preferences.setBool("prefersWinRate", false);
    }

    _prefersWinRate = preferences.getBool("prefersWinRate");
    _isLoaded = true;

    notifyListeners();
  }
}
