import "package:aqua/src/models/anonymous_user.dart";

abstract class AnalyticsService {
  void setUser(AnonymousUser? user);

  void logScreenChange({
    required String screenName,
    Map<String, dynamic> parameters = const {},
  });

  void logEvent({
    required String name,
    Map<String, dynamic> parameters = const {},
  });
}
