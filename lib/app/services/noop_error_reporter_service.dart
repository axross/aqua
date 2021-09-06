import "package:aqua/src/models/anonymous_user.dart";
import "package:aqua/src/services/error_reporter_service.dart";
import "package:flutter/foundation.dart";

class NoopErrorReporterService implements ErrorReporterService {
  NoopErrorReporterService();

  void setUser(AnonymousUser? user) {}

  Future<void> captureException({
    required dynamic exception,
    required StackTrace stackTrace,
  }) async {}

  Future<void> captureFlutterException(FlutterErrorDetails details) async {}
}
