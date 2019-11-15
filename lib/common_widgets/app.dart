import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/pages/simulation_page/simulation_page.dart';
import 'package:aqua/theme_data.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/material.dart';

class AquaApp extends StatefulWidget {
  @override
  State<AquaApp> createState() => _AquaAppState();
}

class _AquaAppState extends State<AquaApp> {
  ValueNotifier<SimulationSession> _simulationSession;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_simulationSession == null) {
      _simulationSession = ValueNotifier(
        SimulationSession.initial(
          analytics: Analytics.of(context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final analytics = Analytics.of(context);

    return Analytics(
      analytics: analytics,
      child: AquaTheme(
        lightThemeData: lightThemeData,
        darkThemeData: darkThemeData,
        child: ValueListenableBuilder<SimulationSession>(
          valueListenable: _simulationSession,
          builder: (context, simulationSession, child) =>
              SimulationSessionProvider(
            simulationSession: simulationSession,
            child: child,
          ),
          child: WidgetsApp(
            title: 'Odds Calculator',
            color: Color(0xff19232e),
            initialRoute: "/",
            routes: {
              "/": (_) => SimulationPage(),
            },
            pageRouteBuilder: <T>(settings, builder) => MaterialPageRoute<T>(
              builder: (context) => builder(context),
              settings: settings,
            ),
          ),
        ),
      ),
    );
  }
}
