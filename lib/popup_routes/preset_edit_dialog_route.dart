import 'package:aqua/common_widgets/bottom_card_dialog_route.dart';
import 'package:aqua/pages/preset_edit_page/preset_edit_page.dart';
import 'package:aqua/view_models/preset_list.dart';
import 'package:flutter/widgets.dart';

class PresetEditDialogRoute extends BottomCardDialogRoute {
  PresetEditDialogRoute({
    RouteSettings settings,
  }) : super(
          builder: (_, __, ___) => PresetEditPage(),
          settings: settings,
        );
}

class PresetEditRouteArgument {
  PresetEditRouteArgument({
    @required this.presetList,
    @required this.selectedGroupIndex,
    @required this.selectedPresetIndex,
  })  : assert(presetList != null),
        assert(selectedGroupIndex != null),
        assert(selectedPresetIndex != null);

  final PresetList presetList;

  final int selectedGroupIndex;

  final int selectedPresetIndex;
}
