import 'package:aqua/common_widgets/bottom_card_dialog_route.dart';
import 'package:aqua/pages/board_setting_page/board_select_page.dart';
import 'package:flutter/widgets.dart';

class BoardSettingDialogRoute extends BottomCardDialogRoute {
  BoardSettingDialogRoute({
    RouteSettings settings,
  }) : super(
          builder: (_, __, ___) => BoardSettingPage(),
          settings: settings,
        );
}
