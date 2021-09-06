import "package:flutter/widgets.dart";

class AquaPopupTransition extends AnimatedWidget {
  AquaPopupTransition({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key, listenable: animation);

  final Animation<double> animation;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: Tween(begin: 0.0, end: 1.0).animate(animation).value,
      child: Transform.scale(
        scale: Tween(begin: .98, end: 1.0).animate(animation).value,
        child: Transform.translate(
          offset: Tween(
            begin: Offset(0.0, -8.0),
            end: Offset(0.0, 0.0),
          ).animate(animation).value,
          child: child,
        ),
      ),
    );
  }
}
