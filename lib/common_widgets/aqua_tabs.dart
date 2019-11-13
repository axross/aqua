import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:flutter/widgets.dart';

class AquaTabs extends StatefulWidget {
  AquaTabs(
      {@required this.items, this.initialIndex = 0, this.onChanged, Key key})
      : assert(items != null),
        assert(items.length > 0),
        super(key: key);

  final List<AquaTabsItemData> items;

  final int initialIndex;

  final void Function(int index) onChanged;

  @override
  _AquaTabsState createState() => _AquaTabsState();
}

@immutable
class AquaTabsItemData {
  const AquaTabsItemData({@required this.label, @required this.icon})
      : assert(label != null),
        assert(icon != null);

  final String label;

  final IconData icon;
}

class _AquaTabsState extends State<AquaTabs> {
  int _selectedIndex;

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Container(
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: theme.playingCardBackgroundColor,
      ),
      padding: EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                left: _selectedIndex *
                        (constraints.maxWidth - (widget.items.length - 1) * 8) /
                        widget.items.length +
                    _selectedIndex * 8,
                child: Container(
                  width:
                      (constraints.maxWidth - (widget.items.length - 1) * 8) /
                          widget.items.length,
                  height: 36,
                  decoration: ShapeDecoration(
                    shape: StadiumBorder(),
                    color: theme.secondaryBackgroundColor,
                  ),
                ),
              ),
              Row(
                children: List.generate(
                  widget.items.length * 2 - 1,
                  (i) => i % 2 == 0
                      ? Expanded(
                          child: _AquaTabItem(
                            label: widget.items[i ~/ 2].label,
                            icon: widget.items[i ~/ 2].icon,
                            isActive: _selectedIndex == i ~/ 2,
                            onPressed: _selectedIndex != i ~/ 2
                                ? () {
                                    setState(() => _selectedIndex = i ~/ 2);

                                    if (widget.onChanged != null) {
                                      widget.onChanged(i ~/ 2);
                                    }
                                  }
                                : () {},
                          ),
                        )
                      : SizedBox(width: 8),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AquaTabItem extends StatefulWidget {
  _AquaTabItem({
    @required this.label,
    @required this.icon,
    this.isActive = false,
    this.onPressed,
    Key key,
  })  : assert(label != null),
        assert(icon != null),
        assert(isActive != null),
        assert(onPressed != null),
        super(key: key);

  final String label;

  final IconData icon;

  final bool isActive;

  final void Function() onPressed;

  @override
  State<_AquaTabItem> createState() => _AquaTabItemState();
}

class _AquaTabItemState extends State<_AquaTabItem>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.isActive ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(_AquaTabItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !oldWidget.isActive) {
      _animationController.forward();
    }

    if (!widget.isActive && oldWidget.isActive) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onPressed,
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
                  begin: theme.secondaryForegroundColor,
                  end: theme.foregroundColor,
                ).animate(_animationController).value,
                size: 16,
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
                  ScaleTransition(
                    scale: Tween(
                      begin: 0.0,
                      end: 1.0,
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
}
