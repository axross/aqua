import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:flutter/widgets.dart';

class TinyStadiumButton extends StatelessWidget {
  TinyStadiumButton({
    @required this.label,
    @required this.foregroundColor,
    @required this.backgroundColor,
    this.onTap,
    Key key,
  })  : assert(label != null),
        assert(foregroundColor != null),
        assert(backgroundColor != null),
        super(key: key);

  final String label;

  final Color foregroundColor;

  final Color backgroundColor;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          shape: StadiumBorder(),
          color: backgroundColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Text(
          label,
          style: theme.textStyle.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
