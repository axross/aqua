import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/hand_range_select_grid.dart';
import 'package:aqua/popup_routes/preset_edit_dialog_route.dart';
import 'package:aqua/view_models/preset_list.dart';
import "package:flutter/widgets.dart";

class PresetEditPage extends StatefulWidget {
  @override
  State<PresetEditPage> createState() => _PresetEditPageState();
}

class _PresetEditPageState extends State<PresetEditPage> {
  PresetList _presetList;
  int _selectedGroupIndex;
  int _selectedPresetIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final argument =
        ModalRoute.of(context).settings.arguments as PresetEditRouteArgument;

    _presetList = argument.presetList;
    _selectedGroupIndex = argument.selectedGroupIndex;
    _selectedPresetIndex = argument.selectedPresetIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: HandRangeSelectGrid(
                initialValue: _presetList
                    .groups[_selectedGroupIndex].presets[_selectedPresetIndex]
                    .toPlayerHandSetting()
                    .onlyHandRange,
                onChanged: (handRange) => _presetList.setPresetPartsAt(
                  _selectedGroupIndex,
                  _selectedPresetIndex,
                  handRange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
