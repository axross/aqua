import "package:amplitude_flutter/amplitude.dart";
import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_environment.dart";
import "package:aqua/src/common_widgets/aqua_preferences.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/simulation_session.dart";
import "package:aqua/src/constants/theme.dart";
import "package:aqua/src/pages/preferences_page.dart";
import "package:aqua/src/pages/preset_select_page.dart";
import "package:aqua/src/pages/simulation_page.dart";
import "package:aqua/src/services/analytics_service.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:flutter/material.dart";

class AquaApp extends StatefulWidget {
  @override
  State<AquaApp> createState() => _AquaAppState();
}

class _AquaAppState extends State<AquaApp> {
  /// A ValueNotifier that holds a SimulationSession inside.
  /// Replace the held SimulationSession to start a new session
  ValueNotifier<SimulationSessionData> _simulationSession;

  /// A singleton AquaPreferenceData object that is used in entire aqua app.
  final AquaPreferenceData _applicationPreferenceData = AquaPreferenceData();

  /// A singleton FirebaseAnalytics object that is used in entire aqua app.
  final AnalyticsService _analytics = AnalyticsService(
    amplitudeAnalytics: Amplitude.getInstance()
      ..init("94ba98446847f79253029f7f8e6d9cf3")
      ..trackingSessionEvents(true),
    firebaseAnalytics: FirebaseAnalytics(),
  );

  @override
  void initState() {
    super.initState();

    _applicationPreferenceData.initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_simulationSession == null) {
      SimulationSessionData simulationSession;

      simulationSession = SimulationSessionData.initial(
        onStartSimulation: () => _analytics.logEvent(
          name: "Start Simulation",
          parameters: {
            "Number of Community Cards": simulationSession.communityCards
                .where((card) => card != null)
                .length,
            "Number of Player Hand Settings":
                simulationSession.playerHandSettings.toList().length,
          },
        ),
        onFinishSimulation: (_) => _analytics.logEvent(
          name: "Finish Simulation",
          parameters: {
            "Number of Community Cards": simulationSession.communityCards
                .where((card) => card != null)
                .length,
            "Number of Player Hand Settings":
                simulationSession.playerHandSettings.toList().length,
          },
        ),
      );

      _simulationSession = ValueNotifier(simulationSession);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AquaEnvironment(
      child: AquaPreferences(
        data: _applicationPreferenceData,
        child: ValueListenableBuilder<SimulationSessionData>(
          valueListenable: _simulationSession,
          builder: (context, simulationSession, child) => SimulationSession(
            simulationSession: simulationSession,
            child: child,
          ),
          child: Analytics(
            analytics: _analytics,
            child: AnimatedBuilder(
              animation: _applicationPreferenceData,
              builder: (context, child) => _applicationPreferenceData.isLoaded
                  ? WidgetsApp(
                      title: "Odds Calculator",
                      color: Color(0xff19232e),
                      builder: (context, child) => AquaTheme(
                        data: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? darkTheme
                            : lightTheme,
                        child: child,
                      ),
                      initialRoute: "/",
                      routes: {
                        "/": (_) => SimulationPage(),
                        "/preset_select": (_) => PresetSelectPage(),
                        "/preferences": (_) => PreferencesPage(),
                      },
                      pageRouteBuilder: <T>(settings, builder) =>
                          MaterialPageRoute<T>(
                        builder: (context) => builder(context),
                        settings: settings,
                      ),
                    )
                  : WidgetsApp(
                      title: "Odds Calculator",
                      color: Color(0xff19232e),
                      builder: (context, child) => AquaTheme(
                        data: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? darkTheme
                            : lightTheme,
                        child: Container(
                          color: Color(0xffffffff),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Color(0xff54a0ff)),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
