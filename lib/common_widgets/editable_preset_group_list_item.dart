import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/plain_text_field.dart';
import 'package:aqua/common_widgets/tiny_stadium_button.dart';
import 'package:aqua/models/player_hand_setting_preset.dart';
import 'package:aqua/models/player_hand_setting_preset_group.dart';
import 'package:flutter/widgets.dart';

class EditablePresetGroupListItem extends StatelessWidget {
  EditablePresetGroupListItem({
    @required this.group,
    @required this.presetsBuilder,
    this.onNameEditEnd,
    this.onDeleteButtonPressed,
    Key key,
  })  : assert(group != null),
        assert(presetsBuilder != null),
        super(key: key);

  final PlayerHandSettingPresetGroup group;

  final Widget Function(BuildContext, List<PlayerHandSettingPreset>)
      presetsBuilder;

  final void Function(String) onNameEditEnd;

  final void Function() onDeleteButtonPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PlainTextField(
                style: theme.textStyle.copyWith(fontSize: 20),
                initialValue: group.name ?? "",
                placeholder: "Tap here to name",
                onUnfocused: (text) {
                  if (onNameEditEnd != null) {
                    onNameEditEnd(text.isEmpty ? null : text);
                  }
                },
              ),
            ),
            TinyStadiumButton(
              label: "Delete",
              foregroundColor: theme.whiteForegroundColor,
              backgroundColor: theme.errorBackgroundColor,
              onTap: () => onDeleteButtonPressed?.call(),
            ),
          ],
        ),
        SizedBox(height: 16),
        presetsBuilder(context, group.presets),
      ],
    );
  }
}
