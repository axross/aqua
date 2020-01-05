import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:flutter/widgets.dart';

class AppBarIshBar extends StatelessWidget {
  AppBarIshBar({@required this.title, Key key})
      : assert(title != null),
        super(key: key);

  final Widget title;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Container(
      color: theme.dimBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 56,
          child: Center(
            child: DefaultTextStyle(
              style: theme.appBarTextStyle,
              child: title,
            ),
          ),
        ),
      ),
    );
  }
}
