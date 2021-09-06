import "package:aqua/src/models/anonymous_user.dart";
import "package:flutter/foundation.dart";

abstract class AuthManagerService extends ChangeNotifier {
  AnonymousUser? get user;

  Future<void> initialize();
}
