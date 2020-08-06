import "package:aqua/src/models/anonymous_user.dart";
import "package:flutter/foundation.dart";
import "package:meta/meta.dart";
import "package:package_info/package_info.dart";
import "package:sentry/sentry.dart";

class ErrorReporterService {
  ErrorReporterService({
    @required String sentryDsn,
  }) : _sentryClient = SentryClient(dsn: sentryDsn);

  final SentryClient _sentryClient;

  AnonymousUser _user;

  void setUser(AnonymousUser user) {
    _user = user;
  }

  void captureException({
    @required dynamic exception,
    @required StackTrace stackTrace,
    Map<String, dynamic> extraParameters = const {},
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();

    _sentryClient.capture(
      event: Event(
        environment: "production",
        release: packageInfo.version,
        exception: exception,
        stackTrace: stackTrace,
        userContext: _user != null ? User(id: _user.id) : null,
        extra: extraParameters,
      ),
    );
  }

  void captureFlutterException(FlutterErrorDetails details) async {
    captureException(
      exception: details.exception,
      stackTrace: details.stack,
      extraParameters: {"details": details.toString()},
    );
  }
}

class ErrorReporterServiceStub implements ErrorReporterService {
  ErrorReporterServiceStub() : _sentryClient = null;

  final SentryClient _sentryClient;

  AnonymousUser _user;

  void setUser(AnonymousUser user) {
    _user = user;
  }

  void captureException({
    @required dynamic exception,
    @required StackTrace stackTrace,
    Map<String, dynamic> extraParameters = const {},
  }) async {}

  void captureFlutterException(FlutterErrorDetails details) async {}
}
