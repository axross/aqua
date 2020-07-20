import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AquaPreferenceData extends ChangeNotifier {
  AquaPreferenceData();

  SharedPreferences preferences;

  bool _isLoaded = false;

  get isLoaded => _isLoaded;

  bool _preferEquity;

  bool get preferEquity => _preferEquity;

  bool _hasPreferEquitySet;

  bool get hasPreferEquitySet => _hasPreferEquitySet;

  Future<void> setPreferEquity(bool value) async {
    _preferEquity = value;
    _hasPreferEquitySet = true;

    notifyListeners();

    await preferences.setBool("preferEquity", value);
    await preferences.setBool("hasPreferEquitySet", true);
  }

  Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();

    if (!preferences.containsKey("preferEquity")) {
      await preferences.setBool("preferEquity", false);
    }

    if (!preferences.containsKey("hasPreferEquitySet")) {
      await preferences.setBool("hasPreferEquitySet", false);
    }

    _preferEquity = preferences.getBool("preferEquity");
    _hasPreferEquitySet = preferences.getBool("hasPreferEquitySet");
    _isLoaded = true;

    notifyListeners();
  }
}
