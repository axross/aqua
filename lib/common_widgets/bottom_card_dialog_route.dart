import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/utilities/system_ui_overlay_style.dart';
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
  final Color barrierColor = Color(0x88000000);

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

    setSystemUIOverlayStyle(
      topColor: theme.appBarBackgroundColor,
      bottomColor: theme.backgroundColor,
    );

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.125),
          end: Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        )),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticInOut,
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
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
