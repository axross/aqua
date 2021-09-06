import "package:aqua/src/models/anonymous_user.dart";
import "package:aqua/src/services/error_reporter_service.dart";
import "package:flutter/foundation.dart";
import "package:package_info/package_info.dart";
import "package:sentry/sentry.dart";

class SentryErrorReporterService implements ErrorReporterService {
  SentryErrorReporterService({required String sentryDsn})
      : _sentryClient = SentryClient(SentryOptions(dsn: sentryDsn)) {
    PackageInfo.fromPlatform().then((packageInfo) {
      Sentry.configureScope((scope) {
        scope.setTag("environment", "production");
        scope.setTag("version", packageInfo.version);
      });
    });
  }

  final SentryClient _sentryClient;

  void setUser(AnonymousUser? user) {
    Sentry.configureScope((scope) {
      scope.user = user != null ? SentryUser(id: user.id) : null;
    });
  }

  Future<void> captureException({
    required dynamic exception,
    required StackTrace stackTrace,
  }) async {
    await _sentryClient.captureException(exception, stackTrace: stackTrace);
  }

  Future<void> captureFlutterException(FlutterErrorDetails details) async {
    Sentry.configureScope((scope) {
      scope.setExtra("details", details.toString());
    });

    await _sentryClient.captureException(
      details.exception,
      stackTrace: details.stack,
    );

    Sentry.configureScope((scope) {
      scope.setExtra("details", null);
    });
  }
}
