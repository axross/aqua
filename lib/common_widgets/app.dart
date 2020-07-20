import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_preferences.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/pages/simulation_page/simulation_page.dart';
import 'package:aqua/theme_data.dart';
import 'package:aqua/view_models/aqua_preference_data.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AquaAppBootstrap extends StatefulWidget {
  @override
  State<AquaAppBootstrap> createState() => _AquaAppBootstrapState();
}

class _AquaAppBootstrapState extends State<AquaAppBootstrap> {
  /// A singleton FirebaseAnalytics object that is used in entire aqua app.
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  /// A singleton AquaPreferenceData object that is used in entire aqua app.
  final AquaPreferenceData _applicationPreferenceData = AquaPreferenceData();

  @override
  void initState() {
    super.initState();

    _applicationPreferenceData.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Analytics(
      analytics: _analytics,
      child: AquaTheme(
        lightThemeData: lightThemeData,
        darkThemeData: darkThemeData,
        child: AquaPreferences(
          data: _applicationPreferenceData,
          child: AnimatedBuilder(
            animation: _applicationPreferenceData,
            builder: (context, child) => _applicationPreferenceData.isLoaded
                ? _AquaApp()
                : _AquaAppWhileLoading(),
          ),
        ),
      ),
    );
  }
}

class _AquaApp extends StatefulWidget {
  @override
  _AquaAppState createState() => _AquaAppState();
}

class _AquaAppState extends State<_AquaApp> {
  /// A ValueNotifier that holds a SimulationSession inside.
  /// Replace the held SimulationSession to start a new session
  ValueNotifier<SimulationSession> _simulationSession;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_simulationSession == null) {
      final analytics = Analytics.of(context);

      _simulationSession =
          ValueNotifier(SimulationSession.initial(analytics: analytics));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SimulationSession>(
      valueListenable: _simulationSession,
      builder: (context, simulationSession, child) => SimulationSessionProvider(
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
    );
  }
}

class _AquaAppWhileLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Odds Calculator',
      color: Color(0xff19232e),
      builder: (context, child) => Container(
        color: AquaTheme.of(context).backgroundColor,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              AquaTheme.of(context).primaryForegroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
