import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:flutter/widgets.dart";

class AquaButton extends StatelessWidget {
  AquaButton({
    this.variant,
    this.label,
    this.icon,
    this.style,
    this.onTap,
    Key key,
  })  : assert(style != null || variant != null),
        super(key: key);

  final AquaButtonVariant variant;

  final String label;

  final IconData icon;

  final AquaButtonStyle style;

  final void Function() onTap;

  AquaButtonStyle _resolveStyle(BuildContext context) {
    if (style != null) return style;
    if (variant != null) return AquaTheme.of(context).buttonStyleSet[variant];

    final defaultStyle = DefaultAquaButtonStyle.of(context);

    assert(defaultStyle != null);

    return defaultStyle;
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context);

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: style.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: aquaButtonHeight,
            maxWidth: double.infinity,
            minHeight: aquaButtonHeight,
            maxHeight: aquaButtonHeight,
          ),
          child: Padding(
            padding: label != null
                ? const EdgeInsets.symmetric(horizontal: 12.0)
                : EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    size: style.labelTextStyle.fontSize * 20 / 14,
                    color: style.labelTextStyle.color,
                  ),
                if (label != null && icon != null) SizedBox(width: 4.0),
                if (label != null)
                  Text(
                    label,
                    style: style.labelTextStyle,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultAquaButtonStyle extends InheritedWidget {
  DefaultAquaButtonStyle({
    @required this.style,
    Widget child,
    Key key,
  })  : assert(style != null),
        super(key: key, child: child);

  final AquaButtonStyle style;

  @override
  bool updateShouldNotify(DefaultAquaButtonStyle old) => style != old.style;

  static AquaButtonStyle of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<DefaultAquaButtonStyle>()
      .style;
}

enum AquaButtonVariant {
  normal,
  primary,
  secondary,
  danger,
}

@immutable
class AquaButtonStyleSet {
  const AquaButtonStyleSet({
    @required this.normal,
    @required this.primary,
    @required this.secondary,
    @required this.danger,
  });

  final AquaButtonStyle normal;

  final AquaButtonStyle primary;

  final AquaButtonStyle secondary;

  final AquaButtonStyle danger;

  // ignore: missing_return
  AquaButtonStyle operator [](AquaButtonVariant variant) {
    switch (variant) {
      case AquaButtonVariant.normal:
        return normal;
      case AquaButtonVariant.primary:
        return primary;
      case AquaButtonVariant.secondary:
        return secondary;
      case AquaButtonVariant.danger:
        return danger;
    }
  }
}

class AquaButtonStyle {
  const AquaButtonStyle({
    @required this.labelTextStyle,
    @required this.backgroundColor,
  });

  final TextStyle labelTextStyle;

  final Color backgroundColor;
}

const aquaButtonHeight = 36.0;
