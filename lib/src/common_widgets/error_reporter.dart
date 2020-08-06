import "package:aqua/src/services/error_reporter_service.dart";
import "package:flutter/widgets.dart";

class ErrorReporter extends InheritedWidget {
  ErrorReporter({
    @required this.service,
    Widget child,
    Key key,
  })  : assert(service != null),
        super(key: key, child: child);

  final ErrorReporterService service;

  @override
  bool updateShouldNotify(ErrorReporter old) => service != old.service;

  static ErrorReporterService of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ErrorReporter>().service;
}
