import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:flutter/widgets.dart';

class PlainTextField extends StatefulWidget {
  PlainTextField({
    this.style,
    this.initialValue = "",
    this.placeholder = "",
    this.onUnfocused,
    Key key,
  }) : super(key: key);

  final TextStyle style;

  final String initialValue;

  final String placeholder;

  final void Function(String) onUnfocused;

  @override
  _PlainTextFieldState createState() => _PlainTextFieldState();
}

class _PlainTextFieldState extends State<PlainTextField> {
  TextEditingController _controller;
  FocusNode _focusNode;
  String _inputtedText;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController.fromValue(
      TextEditingValue(text: widget.initialValue),
    )..addListener(() {
        setState(() {
          _inputtedText = _controller.text;
        });
      });
    _focusNode = FocusNode()
      ..addListener(() {
        if (!_focusNode.hasFocus && widget.onUnfocused != null) {
          widget.onUnfocused(_controller.text);
        }
      });
    _inputtedText = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Stack(
      children: <Widget>[
        if (_inputtedText.isEmpty)
          Text(
            widget.placeholder,
            style: theme.textStyle
                .merge(widget.style)
                .copyWith(color: theme.dimBackgroundColor),
          ),
        EditableText(
          controller: _controller,
          focusNode: _focusNode,
          onSubmitted: (_) => _focusNode.unfocus(),
          selectionColor: theme.primaryBackgroundColor.withOpacity(.5),
          cursorColor: theme.primaryForegroundColor,
          backgroundCursorColor: theme.primaryForegroundColor.withOpacity(.5),
          style: theme.textStyle
              .copyWith(color: theme.foregroundColor)
              .merge(widget.style),
        ),
      ],
    );
  }
}
