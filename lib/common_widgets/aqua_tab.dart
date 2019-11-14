import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AquaTabController extends ChangeNotifier {
  AquaTabController({
    @required this.length,
    int initialSelectedTabIndex = 0,
  })  : assert(length != null),
        assert(length >= 0),
        assert(initialSelectedTabIndex >= 0),
        assert(initialSelectedTabIndex < length),
        _selectedIndex = initialSelectedTabIndex;

  final int length;

  int _selectedIndex;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;

    notifyListeners();
  }
}

class AquaTabBar extends StatelessWidget {
  AquaTabBar({
    @required this.controller,
    @required this.tabs,
    Key key,
  })  : assert(controller != null),
        assert(tabs != null),
        assert(controller.length == tabs.length),
        super(key: key);

  final AquaTabController controller;

  final List<AquaTabItem> tabs;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Container(
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: theme.dimBackgroundColor,
      ),
      padding: EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, _) => Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  left: controller.selectedIndex *
                          (constraints.maxWidth - (controller.length - 1) * 8) /
                          controller.length +
                      controller.selectedIndex * 8,
                  child: Container(
                    width:
                        (constraints.maxWidth - (controller.length - 1) * 8) /
                            controller.length,
                    height: 36,
                    decoration: ShapeDecoration(
                      shape: StadiumBorder(),
                      color: theme.secondaryBackgroundColor,
                    ),
                  ),
                ),
                _AquaTabControllerProvider(
                  controller: controller,
                  child: Row(
                    children: List.generate(
                      controller.length * 2 - 1,
                      (i) => i % 2 == 0
                          ? Expanded(
                              child: _AquaTabIndexProvider(
                                index: i ~/ 2,
                                child: tabs[i ~/ 2],
                              ),
                            )
                          : SizedBox(width: 8),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AquaTabView extends StatelessWidget {
  AquaTabView({
    @required this.controller,
    @required this.views,
    Key key,
  })  : assert(controller != null),
        assert(views != null),
        assert(controller.length == views.length),
        super(key: key);

  final AquaTabController controller;

  final List<Widget> views;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: controller,
        builder: (context, _) => views[controller.selectedIndex],
      );
}

class _AquaTabControllerProvider extends InheritedWidget {
  _AquaTabControllerProvider({@required this.controller, Widget child, Key key})
      : assert(controller != null),
        super(key: key, child: child);

  final AquaTabController controller;

  @override
  bool updateShouldNotify(_AquaTabControllerProvider old) =>
      old.controller != controller;

  static AquaTabController of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(_AquaTabControllerProvider)
              as _AquaTabControllerProvider)
          .controller;
}

class _AquaTabIndexProvider extends InheritedWidget {
  _AquaTabIndexProvider({@required this.index, Widget child, Key key})
      : assert(index != null),
        super(key: key, child: child);

  final int index;

  @override
  bool updateShouldNotify(_AquaTabIndexProvider old) => old.index != index;

  static int of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(_AquaTabIndexProvider)
              as _AquaTabIndexProvider)
          .index;
}

class AquaTabItem extends StatefulWidget {
  AquaTabItem({
    @required this.label,
    @required this.icon,
    Key key,
  })  : assert(label != null),
        assert(icon != null),
        super(key: key);

  final String label;

  final IconData icon;

  @override
  State<AquaTabItem> createState() => _AquaTabItemState();
}

class _AquaTabItemState extends State<AquaTabItem>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  Function _listener;

  AquaTabController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controller == null) {
      _controller = _AquaTabControllerProvider.of(context);
    }

    final selfIndex = _AquaTabIndexProvider.of(context);

    if (_animationController == null) {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        value: selfIndex == _controller.selectedIndex ? 1 : 0,
      );

      _listener = () {
        if (selfIndex == _controller.selectedIndex) {
          _animationController.forward();
        }

        if (selfIndex != _controller.selectedIndex) {
          _animationController.reverse();
        }
      };

      _controller.addListener(_listener);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _AquaTabControllerProvider.of(context);
    final theme = AquaTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final selfIndex = _AquaTabIndexProvider.of(context);

        controller.selectedIndex = selfIndex;

        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) => Icon(
                widget.icon,
                color: ColorTween(
                  begin: theme.foregroundColor,
                  end: theme.foregroundColor,
                ).animate(_animationController).value,
                size: 20,
              ),
            ),
            SizeTransition(
              axis: Axis.horizontal,
              sizeFactor: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(_animationController),
              child: Row(
                children: [
                  SizedBox(width: 4),
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 1),
                      end: Offset(0, 0),
                    ).animate(_animationController),
                    child: Text(
                      widget.label,
                      style: theme.textStyle
                          .copyWith(color: theme.foregroundColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    assert(_controller != null);
    assert(_listener != null);

    _controller.removeListener(_listener);

    super.dispose();
  }
}
