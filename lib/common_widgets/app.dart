import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_preferences.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/pages/simulation_page/simulation_page.dart';
import 'package:aqua/theme_data.dart';
import 'package:aqua/view_models/aqua_preference_data.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/material.dart';

class AquaApp extends StatefulWidget {
  @override
  State<AquaApp> createState() => _AquaAppState();
}

class _AquaAppState extends State<AquaApp> {
  ValueNotifier<SimulationSession> _simulationSession;

  AquaPreferenceData applicationPreferenceData;

  @override
  void initState() {
    super.initState();

    applicationPreferenceData = AquaPreferenceData();

    applicationPreferenceData.initialize();
  }

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
    return AquaTheme(
      lightThemeData: lightThemeData,
      darkThemeData: darkThemeData,
      child: AquaPreferences(
        data: applicationPreferenceData,
        child: AnimatedBuilder(
          animation: applicationPreferenceData,
          builder: (context, child) => applicationPreferenceData.isLoaded
              ? ValueListenableBuilder<SimulationSession>(
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
                    pageRouteBuilder: <T>(settings, builder) =>
                        MaterialPageRoute<T>(
                      builder: (context) => builder(context),
                      settings: settings,
                    ),
                  ),
                )
              : WidgetsApp(
                  title: 'Odds Calculator',
                  color: Color(0xff19232e),
                  builder: (context, child) => _AquaAppLoading(),
                ),
        ),
      ),
    );
  }
}

class _AquaAppLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AquaTheme.of(context).backgroundColor,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(
            AquaTheme.of(context).primaryForegroundColor,
          ),
        ),
      ),
    );
  }
}
