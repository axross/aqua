import "package:flutter/widgets.dart";
import "package:shared_preferences/shared_preferences.dart";

class AquaPreferenceData extends ChangeNotifier {
  AquaPreferenceData();

  SharedPreferences preferences;

  bool _isLoaded = false;

  get isLoaded => _isLoaded;

  bool _preferWinRate;

  bool get preferWinRate => _preferWinRate;

  bool _hasPreferEquitySet;

  bool get hasPreferEquitySet => _hasPreferEquitySet;

  Future<void> setPreferEquity(bool value) async {
    _preferWinRate = value;
    _hasPreferEquitySet = true;

    notifyListeners();

    await preferences.setBool("preferWinRate", value);
    await preferences.setBool("hasPreferEquitySet", true);
  }

  Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();

    if (!preferences.containsKey("preferWinRate")) {
      await preferences.setBool("preferWinRate", false);
    }

    if (!preferences.containsKey("hasPreferEquitySet")) {
      await preferences.setBool("hasPreferEquitySet", false);
    }

    _preferWinRate = preferences.getBool("preferWinRate");
    _hasPreferEquitySet = preferences.getBool("hasPreferEquitySet");
    _isLoaded = true;

    notifyListeners();
  }
}
