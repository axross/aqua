import "package:flutter/widgets.dart";
import "package:shared_preferences/shared_preferences.dart";

class AquaPreferenceData extends ChangeNotifier {
  AquaPreferenceData();

  SharedPreferences preferences;

  bool _isLoaded = false;

  get isLoaded => _isLoaded;

  bool _preferWinRate;

  bool get preferWinRate => _preferWinRate;

  Future<void> setPreferWinRate(bool value) async {
    _preferWinRate = value;

    notifyListeners();

    await preferences.setBool("preferWinRate", value);
  }

  Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();

    if (!preferences.containsKey("preferWinRate")) {
      await preferences.setBool("preferWinRate", false);
    }

    _preferWinRate = preferences.getBool("preferWinRate");
    _isLoaded = true;

    notifyListeners();
  }
}
