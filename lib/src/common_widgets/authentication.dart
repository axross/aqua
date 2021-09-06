import "package:aqua/src/services/auth_manager_service.dart";
import "package:flutter/widgets.dart";

class Authentication extends InheritedWidget {
  Authentication({
    Key? key,
    required this.manager,
    required Widget child,
  }) : super(key: key, child: child);

  final AuthManagerService manager;

  @override
  bool updateShouldNotify(Authentication old) => manager != old.manager;

  static AuthManagerService of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Authentication>()!.manager;
}
