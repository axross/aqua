import "package:aqua/app/main_route.dart";
import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_environment.dart";
import "package:aqua/src/common_widgets/aqua_preferences.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/authentication.dart";
import "package:aqua/src/common_widgets/error_reporter.dart";
import "package:aqua/src/constants/theme.dart";
import "package:aqua/src/services/analytics_service.dart";
import "package:aqua/src/services/auth_manager_service.dart";
import "package:aqua/src/services/error_reporter_service.dart";
import "package:flutter/material.dart";

class AquaApp extends StatefulWidget {
  AquaApp({
    Key? key,
    this.prepare,
    required this.analyticsService,
    required this.authManagerService,
    required this.errorReporter,
    required this.applicationPreferenceData,
  }) : super(key: key);

  final AnalyticsService analyticsService;

  final AuthManagerService authManagerService;

  final ErrorReporterService errorReporter;

  final AquaPreferenceData applicationPreferenceData;

  final Future<void> Function()? prepare;

  @override
  State<AquaApp> createState() => _AquaAppState();
}

class _AquaAppState extends State<AquaApp> {
  /// A singleton AquaPreferenceData object that is used in entire aqua app.

  bool _isReady = false;

  @override
  void initState() {
    super.initState();

    widget.authManagerService.addListener(() {
      final user = widget.authManagerService.user;

      widget.analyticsService.setUser(user);
      widget.errorReporter.setUser(user);
    });

    final user = widget.authManagerService.user;

    widget.analyticsService.setUser(user);
    widget.errorReporter.setUser(user);

    if (widget.prepare == null) {
      _isReady = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.prepare != null) {
      widget.prepare!().then((_) {
        setState(() {
          _isReady = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ErrorReporter(
      service: widget.errorReporter,
      child: AquaEnvironment(
        child: Authentication(
          manager: widget.authManagerService,
          child: Analytics(
            analytics: widget.analyticsService,
            child: AquaPreferences(
              data: widget.applicationPreferenceData,
              child: _isReady
                  ? WidgetsApp(
                      title: "Odds Calculator",
                      color: Color(0xff19232e),
                      builder: (context, child) => AquaTheme(
                        data: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? darkTheme
                            : lightTheme,
                        child: child!,
                      ),
                      onGenerateRoute: (settings) => MainRoute(),
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
