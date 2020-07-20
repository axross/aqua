import 'dart:ui';
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/utilities/system_ui_overlay_style.dart";
import "package:flutter/widgets.dart";

class BottomCardDialogRoute<T> extends PopupRoute<T> {
  BottomCardDialogRoute({
    @required this.builder,
    RouteSettings settings,
  })  : assert(builder != null),
        super(settings: settings);

  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) builder;

  @override
  final bool barrierDismissible = true;

  @override
  final String barrierLabel = 'Close';

  @override
  final Color barrierColor = null;

  @override
  final Duration transitionDuration = const Duration(milliseconds: 300);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final theme = AquaTheme.of(context);
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );

    setSystemUIOverlayStyle(
      topColor: Color.lerp(
        theme.dimBackgroundColor,
        const Color(0xff000000),
        Tween(begin: 0.0, end: .5).animate(curvedAnimation).value,
      ),
      bottomColor: theme.backgroundColor,
    );

    return Stack(
      children: [
        IgnorePointer(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: Tween<double>(begin: 0, end: 6)
                  .animate(curvedAnimation)
                  .value,
              sigmaY: Tween<double>(begin: 0, end: 6)
                  .animate(curvedAnimation)
                  .value,
            ),
            child: Container(
              color: ColorTween(
                begin: const Color(0x00000000),
                end: const Color(0x7f000000),
              ).animate(curvedAnimation).value,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.125),
              end: const Offset(0, 0),
            ).animate(curvedAnimation),
            child: FadeTransition(
              opacity: curvedAnimation,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: DefaultTextStyle(
                      style: TextStyle(decoration: TextDecoration.none),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      builder(context, animation, secondaryAnimation);
}
