import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:flutter/widgets.dart';

class NameTextEdit extends StatefulWidget {
  NameTextEdit({
    @required this.initialValue,
    this.onEditEnd,
    Key key,
  })  : assert(initialValue != null),
        super(key: key);

  final String initialValue;

  final void Function(String) onEditEnd;

  @override
  State<NameTextEdit> createState() => _NameTextEditState();
}

class _NameTextEditState extends State<NameTextEdit> {
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController.fromValue(
      TextEditingValue(text: widget.initialValue),
    );
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && widget.onEditEnd != null) {
        widget.onEditEnd(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return EditableText(
      controller: _controller,
      focusNode: _focusNode,
      onSubmitted: (_) => _focusNode.unfocus(),
      selectionColor: theme.primaryBackgroundColor.withOpacity(.5),
      cursorColor: theme.primaryForegroundColor,
      backgroundCursorColor: theme.primaryForegroundColor.withOpacity(.5),
      style: theme.textStyle.copyWith(
        fontSize: 20,
        color: theme.foregroundColor,
      ),
    );
  }
}
