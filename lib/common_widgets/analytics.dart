import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

class Analytics extends InheritedWidget {
  Analytics({
    @required this.analytics,
    @required this.child,
  })  : assert(analytics != null),
        assert(child != null);

  final FirebaseAnalytics analytics;

  final Widget child;

  @override
  bool updateShouldNotify(Analytics old) => analytics != old.analytics;

  static FirebaseAnalytics of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Analytics) as Analytics).analytics;
}
