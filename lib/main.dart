import "dart:async";
import "package:amplitude_flutter/amplitude.dart";
import "package:aqua/app/app.dart";
import "package:aqua/app/services/amplitude_analytics_service.dart";
import "package:aqua/app/services/firebase_auth_manager_service.dart";
import "package:aqua/app/services/noop_error_reporter_service.dart";
import "package:aqua/app/services/sentry_error_reporter_service.dart";
import 'package:aqua/src/common_widgets/aqua_preferences.dart';
import "package:firebase_analytics/firebase_analytics.dart";
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authManagerService = FirebaseAuthManagerService();
  final amplitudeInstance = Amplitude.getInstance();
  final analyticsService = AmplitudeAnalyticsService(
    amplitudeAnalytics: amplitudeInstance,
    firebaseAnalytics: FirebaseAnalytics(),
  );
  final applicationPreferenceData = AquaPreferenceData();

  if (!kDebugMode) {
    final errorReporter = SentryErrorReporterService(
      sentryDsn:
          "https://7f698d26a29e495881c4adf639830a1a@o30395.ingest.sentry.io/5375048",
    );

    FlutterError.onError = (details) {
      errorReporter.captureFlutterException(details);
    };

    runZonedGuarded(() async {
      runApp(AquaApp(
        analyticsService: analyticsService,
        authManagerService: authManagerService,
        errorReporter: errorReporter,
        applicationPreferenceData: applicationPreferenceData,
        prepare: () async {
          await Firebase.initializeApp();
          await authManagerService.initialize();
          await amplitudeInstance.init("94ba98446847f79253029f7f8e6d9cf3");
          await amplitudeInstance
              .setUserProperties({"Environment": "production"});
          await amplitudeInstance.trackingSessionEvents(true);
          await applicationPreferenceData.initialize();
        },
      ));
    }, (exception, stackTrace) async {
      errorReporter.captureException(
        exception: exception,
        stackTrace: stackTrace,
      );
    });
  } else {
    runApp(AquaApp(
      analyticsService: analyticsService,
      authManagerService: authManagerService,
      errorReporter: NoopErrorReporterService(),
      applicationPreferenceData: applicationPreferenceData,
    ));
  }
}
