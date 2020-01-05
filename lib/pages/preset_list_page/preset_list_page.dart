import 'package:aqua/common_widgets/app_bar_ish_bar.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/editable_preset_group_list_item.dart';
import 'package:aqua/common_widgets/editable_preset_list_item.dart';
import 'package:aqua/common_widgets/new_preset_list_item.dart';
import 'package:aqua/popup_routes/preset_edit_dialog_route.dart';
import 'package:aqua/view_models/preset_list.dart';
import 'package:flutter/widgets.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class PresetListPage extends StatefulWidget {
  @override
  _PresetListPageState createState() => _PresetListPageState();
}

class _PresetListPageState extends State<PresetListPage> {
  ScrollController _scrollController;
  PresetList _presetList;

  @override
  void initState() {
    super.initState();

    _presetList = PresetList();
    _scrollController = ScrollController();

    _presetList.loadSavedPresets();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Container(
      color: theme.backgroundColor,
      child: Column(
        children: [
          AppBarIshBar(title: Text("Presets")),
          Expanded(
            child: AnimatedBuilder(
              animation: _presetList,
              builder: (context, _) => KeyboardAvoider(
                autoScroll: true,
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
                  children: List.generate(
                    _presetList.groups.length * 2 - 1,
                    (i) => i % 2 == 0
                        ? EditablePresetGroupListItem(
                            key: ObjectKey(_presetList.groups[i ~/ 2]),
                            onNameEditEnd: (name) =>
                                _presetList.setGroupNameAt(i ~/ 2, name),
                            onDeleteButtonPressed: () {
                              _presetList.deleteGroupAt(i ~/ 2);
                            },
                            presetsBuilder: (context, presets) => Column(
                              children: [
                                ...List.generate(
                                  presets.length * 2 - 1,
                                  (j) => j % 2 == 0
                                      ? EditablePresetListItem(
                                          key: ObjectKey(_presetList
                                              .groups[i ~/ 2].presets[j ~/ 2]),
                                          preset: presets[j ~/ 2],
                                          onPressed: () =>
                                              Navigator.of(context).push(
                                            PresetEditDialogRoute(
                                              settings: RouteSettings(
                                                arguments:
                                                    PresetEditRouteArgument(
                                                  presetList: _presetList,
                                                  selectedGroupIndex: i ~/ 2,
                                                  selectedPresetIndex: j ~/ 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onNameEditEnd: (name) =>
                                              _presetList.setPresetNameAt(
                                                  i ~/ 2, j ~/ 2, name),
                                        )
                                      : SizedBox(height: 16),
                                ),
                                SizedBox(height: 16),
                                NewPresetListItem(
                                  onPressed: () {
                                    _presetList.addNewPresetToGroupAt(i ~/ 2);
                                  },
                                ),
                              ],
                            ),
                            group: _presetList.groups[i ~/ 2],
                          )
                        : const SizedBox(height: 24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
