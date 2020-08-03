import "dart:async" show runZonedGuarded;
import "package:aqua/src/app.dart";
import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";
import "package:package_info/package_info.dart";
import "package:sentry/sentry.dart";

void main() async {
  if (!kDebugMode) {
    final SentryClient sentryClient = SentryClient(
        dsn:
            "https://7f698d26a29e495881c4adf639830a1a@o30395.ingest.sentry.io/5375048");

    FlutterError.onError = (details) async {
      final packageInfo = await PackageInfo.fromPlatform();

      sentryClient.capture(
        event: Event(
          exception: details.exception,
          stackTrace: details.stack,
          extra: {"details": details.toString()},
          environment: "production",
          release: packageInfo.version,
        ),
      );
    };

    runZonedGuarded(() async {
      runApp(AquaApp());
    }, (exception, stackTrace) async {
      final packageInfo = await PackageInfo.fromPlatform();

      sentryClient.capture(
        event: Event(
          exception: exception,
          stackTrace: stackTrace,
          environment: "production",
          release: packageInfo.version,
        ),
      );
    });
  } else {
    runApp(AquaApp());
  }
}
