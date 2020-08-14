import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:flutter/widgets.dart";

class AquaTabBar extends StatefulWidget {
  AquaTabBar({
    Key key,
    @required this.items,
    this.initialSelectedIndex = 0,
    this.onChanged,
  }) : super(key: key);

  final List<AquaTabBarItem> items;

  final int initialSelectedIndex;

  final void Function(int index) onChanged;

  @override
  _AquaTabBarState createState() => _AquaTabBarState();
}

class _AquaTabBarState extends State<AquaTabBar> {
  int _selectedIndex;

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AquaTheme.of(context).scaffoldStyle.backgroundColor,
        boxShadow: AquaTheme.of(context)
            .elevationBoxShadows
            .map((boxShadow) => BoxShadow(
                  color: boxShadow.color,
                  offset: boxShadow.offset * -1,
                  blurRadius: boxShadow.blurRadius,
                  spreadRadius: boxShadow.spreadRadius,
                ))
            .toList(),
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: List.generate(widget.items.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });

                        if (widget.onChanged != null) {
                          widget.onChanged(index);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 4),
                        child: Column(
                          children: [
                            Icon(
                              widget.items[index].icon,
                              size: 24,
                              color: _selectedIndex == index
                                  ? AquaTheme.of(context).cursorColor
                                  : AquaTheme.of(context)
                                      .textStyleSet
                                      .caption
                                      .color,
                            ),
                            TweenAnimationBuilder(
                              tween: TextStyleTween(
                                begin: AquaTheme.of(context)
                                    .textStyleSet
                                    .caption
                                    .copyWith(fontSize: 10),
                                end: AquaTheme.of(context)
                                    .textStyleSet
                                    .caption
                                    .copyWith(
                                      color: _selectedIndex == index
                                          ? AquaTheme.of(context).cursorColor
                                          : AquaTheme.of(context)
                                              .textStyleSet
                                              .caption
                                              .color,
                                      fontSize: 10,
                                    ),
                              ),
                              duration: Duration(milliseconds: 200),
                              builder: (context, style, _) => Text(
                                widget.items[index].label,
                                style: style,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}

@immutable
class AquaTabBarItem {
  const AquaTabBarItem({
    @required this.label,
    @required this.icon,
  })  : assert(label != null),
        assert(icon != null);

  final String label;

  final IconData icon;
}
