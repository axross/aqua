import "package:amplitude_flutter/amplitude.dart";
import "package:aqua/src/common_widgets/simulation_session.dart";
import "package:aqua/src/models/anonymous_user.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:flutter/widgets.dart" show immutable, required;

@immutable
class AnalyticsService {
  const AnalyticsService({
    @required Amplitude amplitudeAnalytics,
    @required FirebaseAnalytics firebaseAnalytics,
  })  : assert(amplitudeAnalytics != null),
        assert(firebaseAnalytics != null),
        _amplitudeAnalytics = amplitudeAnalytics,
        _firebaseAnalytics = firebaseAnalytics;

  final Amplitude _amplitudeAnalytics;

  final FirebaseAnalytics _firebaseAnalytics;

  void setUser(AnonymousUser user) {
    _amplitudeAnalytics.setUserId(user?.id);
    _firebaseAnalytics.setUserId(user?.id);
  }

  void logScreenChange({
    @required String screenName,
    Map<String, dynamic> parameters = const {},
  }) {
    final encodedParameters = _encodeParameters(parameters);

    _amplitudeAnalytics.logEvent(
      "Transition to $screenName",
      eventProperties: encodedParameters,
    );
    _firebaseAnalytics.logEvent(
      name: _toSnakeCase("Transition to $screenName"),
      parameters: _snakeCaseParameters(encodedParameters),
    );
    _firebaseAnalytics.setCurrentScreen(
      screenName: screenName,
    );
  }

  void logEvent({
    @required String name,
    Map<String, dynamic> parameters = const {},
  }) {
    final encodedParameters = _encodeParameters(parameters);

    _amplitudeAnalytics.logEvent(
      name,
      eventProperties: encodedParameters,
    );
    _firebaseAnalytics.logEvent(
      name: _toSnakeCase(name),
      parameters: _snakeCaseParameters(encodedParameters),
    );
  }

  Map<String, dynamic> _encodeParameters(Map<String, dynamic> parameters) {
    assert(parameters != null);

    return parameters.map((key, value) {
      dynamic processedValue;

      if (value is num || value is String || value is bool) {
        processedValue = value;
      }

      if (value is PlayerHandSettingType) {
        processedValue = _PlayerHandSettingTypeString[value];
      }

      return MapEntry(key, processedValue);
    });
  }

  Map<String, dynamic> _snakeCaseParameters(Map<String, dynamic> parameters) {
    assert(parameters != null);

    return parameters.map((key, value) => MapEntry(_toSnakeCase(key), value));
  }
}

const _PlayerHandSettingTypeString = {
  PlayerHandSettingType.holeCards: "Hole Cards",
  PlayerHandSettingType.handRange: "Hand Range",
  PlayerHandSettingType.mixed: "Mixed",
};

String _toSnakeCase(String value) {
  return value
      .replaceAll(RegExp(r" +"), "_")
      .replaceAllMapped(
        RegExp(r"[A-Z]"),
        (match) => String.fromCharCode(match[0].codeUnitAt(0) + 32),
      )
      .replaceAll(RegExp(r"[^A-Za-z0-9_]+"), "");
}
