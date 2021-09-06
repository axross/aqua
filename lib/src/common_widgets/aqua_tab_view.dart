import "package:flutter/widgets.dart";

class AquaTabView extends StatefulWidget {
  AquaTabView({
    Key? key,
    required this.views,
    this.activeViewIndex = 0,
  })  : assert(views.length >= 1),
        assert(activeViewIndex < views.length),
        super(key: key);

  final List<Widget> views;

  final int activeViewIndex;

  @override
  State<AquaTabView> createState() => _AquaTabViewState();
}

class _AquaTabViewState extends State<AquaTabView> {
  late int _previousActiveViewIndex;

  @override
  void initState() {
    super.initState();

    _previousActiveViewIndex = widget.activeViewIndex;
  }

  @override
  void didUpdateWidget(AquaTabView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activeViewIndex != widget.activeViewIndex) {
      setState(() {
        _previousActiveViewIndex = oldWidget.activeViewIndex;
      });
    }
  }

  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: Tween<double>(begin: 0.5, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: SlideTransition(
            position: _previousActiveViewIndex > widget.activeViewIndex
                ? Tween<Offset>(
                    begin: Offset(-0.05, 0),
                    end: Offset(0, 0),
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ))
                : Tween<Offset>(
                    begin: Offset(0.05, 0),
                    end: Offset(0, 0),
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
            child: child,
          ),
        ),
        child: widget.views[widget.activeViewIndex],
      );
}
