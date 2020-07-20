import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:flutter/material.dart";

class ProgressIndicator extends StatelessWidget {
  ProgressIndicator({@required this.progress, Key key})
      : assert(progress != null),
        super(key: key);

  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: 2),
      child: LinearProgressIndicator(
        value: progress,
        valueColor: progress == 1.0
            ? AlwaysStoppedAnimation<Color>(Color(0x00000000))
            : AlwaysStoppedAnimation<Color>(
                theme.dimForegroundColor,
              ),
        backgroundColor: Color(0x00000000),
      ),
    );
  }
}
