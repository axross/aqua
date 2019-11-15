import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

class Analytics extends InheritedWidget {
  Analytics({
    @required this.analytics,
    Widget child,
    Key key,
  })  : assert(analytics != null),
        super(key: key, child: child);

  final FirebaseAnalytics analytics;

  @override
  bool updateShouldNotify(Analytics old) => analytics != old.analytics;

  static FirebaseAnalytics of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Analytics) as Analytics).analytics;
}
