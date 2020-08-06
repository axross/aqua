import "package:meta/meta.dart";

@immutable
class AnonymousUser {
  AnonymousUser({@required this.id}) : assert(id != null);

  final String id;
}
