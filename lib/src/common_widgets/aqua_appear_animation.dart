import "package:aqua/src/common_widgets/aqua_popup_transition.dart";
import "package:flutter/widgets.dart";

@immutable
class AquaAppearAnimation extends StatefulWidget {
  AquaAppearAnimation({Key? key, required this.child, this.isVisible = false})
      : super(key: key);

  final bool isVisible;

  final Widget child;

  @override
  _AquaAppearAnimationState createState() => _AquaAppearAnimationState();
}

class _AquaAppearAnimationState extends State<AquaAppearAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _curvedAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
      value: widget.isVisible ? 1.0 : 0.0,
    );
    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AquaPopupTransition(
      animation: _curvedAnimation,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => _animationController.isDismissed
            ? SizedBox(height: 0)
            : widget.child,
      ),
    );
  }
}
