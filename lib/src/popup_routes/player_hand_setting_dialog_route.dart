import 'package:aqua/src/common_widgets/bottom_card_dialog_route.dart';
import 'package:aqua/src/pages/player_hand_setting_page/player_hand_setting_page.dart';
import 'package:flutter/widgets.dart';

class PlayerHandSettingDialogRoute extends BottomCardDialogRoute {
  PlayerHandSettingDialogRoute({
    RouteSettings settings,
  }) : super(
          builder: (_, __, ___) => PlayerHandSettingPage(),
          settings: settings,
        );
}
