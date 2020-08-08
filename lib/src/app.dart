import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_environment.dart";
import "package:aqua/src/common_widgets/aqua_preferences.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/authentication.dart";
import "package:aqua/src/common_widgets/error_reporter.dart";
import "package:aqua/src/common_widgets/current_simulation_session.dart";
import "package:aqua/src/constants/theme.dart";
import "package:aqua/src/pages/preferences_page.dart";
import "package:aqua/src/pages/preset_select_page.dart";
import "package:aqua/src/pages/simulation_page.dart";
import "package:aqua/src/services/analytics_service.dart";
import "package:aqua/src/services/authentication_manager.dart";
import "package:aqua/src/services/error_reporter_service.dart";
import "package:aqua/src/view_models/simulation_session.dart";
import "package:flutter/material.dart";

class AquaApp extends StatefulWidget {
  AquaApp({
    Key key,
    @required this.analyticsService,
    @required this.authenticationManager,
    @required this.errorReporter,
  })  : assert(authenticationManager != null),
        super(key: key);

  final AnalyticsService analyticsService;

  final AuthenticationManager authenticationManager;

  final ErrorReporterService errorReporter;

  @override
  State<AquaApp> createState() => _AquaAppState();
}

class _AquaAppState extends State<AquaApp> {
  /// A ValueNotifier that holds a SimulationSession inside.
  /// Replace the held SimulationSession to start a new session
  ValueNotifier<SimulationSession> _simulationSession;

  /// A singleton AquaPreferenceData object that is used in entire aqua app.
  final AquaPreferenceData _applicationPreferenceData = AquaPreferenceData();

  @override
  void initState() {
    super.initState();

    _applicationPreferenceData.initialize();

    widget.authenticationManager.addListener(() {
      final user = widget.authenticationManager.user;

      widget.analyticsService.setUser(user);
      widget.errorReporter.setUser(user);
    });

    final user = widget.authenticationManager.user;

    widget.analyticsService.setUser(user);
    widget.errorReporter.setUser(user);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_simulationSession == null) {
      SimulationSession simulationSession;

      simulationSession = SimulationSession.initial(
        onStartSimulation: () => widget.analyticsService.logEvent(
          name: "Start Simulation",
          parameters: {
            "Number of Community Cards":
                simulationSession.communityCards.toSet().length,
            "Number of Hand Ranges": simulationSession.handRanges.length,
          },
        ),
        onFinishSimulation: (snapshot) {
          widget.analyticsService.logEvent(
            name: "Finish Simulation",
            parameters: {
              "Number of Community Cards":
                  simulationSession.communityCards.toSet().length,
              "Number of Hand Ranges": simulationSession.handRanges.length,
            },
          );
        },
      );

      _simulationSession = ValueNotifier(simulationSession);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ErrorReporter(
      service: widget.errorReporter,
      child: AquaEnvironment(
        child: Authentication(
          manager: widget.authenticationManager,
          child: Analytics(
            analytics: widget.analyticsService,
            child: AquaPreferences(
              data: _applicationPreferenceData,
              child: ValueListenableBuilder<SimulationSession>(
                valueListenable: _simulationSession,
                builder: (context, simulationSession, child) =>
                    CurrentSimulationSession(
                  simulationSession: simulationSession,
                  child: child,
                ),
                child: AnimatedBuilder(
                  animation: _applicationPreferenceData,
                  builder: (context, child) => _applicationPreferenceData
                          .isLoaded
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
        ),
      ),
    );
  }
}
