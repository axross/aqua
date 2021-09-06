import "package:flutter/widgets.dart";

@immutable
class Fill extends StatelessWidget {
  const Fill({@required this.child, Key? key}) : super(key: key);

  final child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(MediaQuery.of(context).size),
      child: child,
    );
  }
}
