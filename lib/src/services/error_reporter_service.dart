import "package:aqua/src/models/anonymous_user.dart";
import "package:flutter/foundation.dart";

abstract class ErrorReporterService {
  void setUser(AnonymousUser? user);

  Future<void> captureException({
    required dynamic exception,
    required StackTrace stackTrace,
  });

  Future<void> captureFlutterException(FlutterErrorDetails details);
}
