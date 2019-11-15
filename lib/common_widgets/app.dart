import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/pages/simulation_page/simulation_page.dart';
import 'package:aqua/theme_data.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AquaApp extends StatefulWidget {
  AquaApp({@required this.analytics, Key key})
      : assert(analytics != null),
        super(key: key);

  final FirebaseAnalytics analytics;

  @override
  State<AquaApp> createState() => _AquaAppState();
}

class _AquaAppState extends State<AquaApp> {
  SimulationSession _simulationSession;

  @override
  void initState() {
    super.initState();

    _simulationSession = SimulationSession.initial(
      analytics: widget.analytics,
    );
  }

  @override
  Widget build(BuildContext context) => Analytics(
        analytics: widget.analytics,
        child: AquaTheme(
          lightThemeData: lightThemeData,
          darkThemeData: darkThemeData,
          child: SimulationSessionProvider(
            simulationSession: _simulationSession,
            child: WidgetsApp(
              title: 'Odds Calculator',
              color: Color(0xff19232e),
              initialRoute: "/",
              routes: {
                "/": (_) => SimulationPage(),
              },
              pageRouteBuilder: <T>(settings, builder) =>
                  MaterialPageRoute<T>(builder: builder, settings: settings),
            ),
          ),
        ),
      );
}
