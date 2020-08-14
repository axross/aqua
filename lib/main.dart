import "dart:async" show runZonedGuarded;
import "package:amplitude_flutter/amplitude.dart";
import "package:aqua/app/app.dart";
import "package:aqua/src/services/analytics_service.dart";
import "package:aqua/src/services/authentication_manager.dart";
import "package:aqua/src/services/error_reporter_service.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final authenticationManager = AuthenticationManager()..initialize();
  final analyticsService = AnalyticsService(
    amplitudeAnalytics: Amplitude.getInstance()
      ..init("94ba98446847f79253029f7f8e6d9cf3")
      ..trackingSessionEvents(true),
    firebaseAnalytics: FirebaseAnalytics(),
  );

  if (!kDebugMode) {
    final errorReporter = ErrorReporterService(
        sentryDsn:
            "https://7f698d26a29e495881c4adf639830a1a@o30395.ingest.sentry.io/5375048");

    FlutterError.onError = (details) {
      errorReporter.captureFlutterException(details);
    };

    runZonedGuarded(() async {
      runApp(AquaApp(
        analyticsService: analyticsService,
        authenticationManager: authenticationManager,
        errorReporter: errorReporter,
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
      authenticationManager: authenticationManager,
      errorReporter: ErrorReporterServiceStub(),
    ));
  }
}
