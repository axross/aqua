import "package:aqua/src/services/analytics_service.dart";
import "package:flutter/widgets.dart";

class Analytics extends InheritedWidget {
  Analytics({
    required this.analytics,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final AnalyticsService analytics;

  @override
  bool updateShouldNotify(Analytics old) => analytics != old.analytics;

  static AnalyticsService of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Analytics>()!.analytics;
}
