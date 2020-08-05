import "package:aqua/src/services/authentication_manager.dart";
import "package:flutter/widgets.dart";

class Authentication extends InheritedWidget {
  Authentication({
    Key key,
    @required this.manager,
    Widget child,
  })  : assert(manager != null),
        super(key: key, child: child);

  final AuthenticationManager manager;

  @override
  bool updateShouldNotify(Authentication old) => manager != old.manager;

  static AuthenticationManager of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Authentication>().manager;
}
