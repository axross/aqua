import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/popup_routes/board_setting_dialog_route%20copy.dart';
import 'package:aqua/popup_routes/player_hand_setting_dialog_route.dart';
import 'package:aqua/utilities/system_ui_overlay_style.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/widgets.dart';
import './app_bar_ish_bar.dart';
import './board.dart';
import './error_message.dart';
import './player_list.dart';
import './progress_indicator.dart';

class SimulationPage extends StatefulWidget {
  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final theme = AquaTheme.of(context);

    setSystemUIOverlayStyle(
      topColor: theme.dimBackgroundColor,
      bottomColor: theme.backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final simulationSession = SimulationSessionProvider.of(context);

    return AnimatedBuilder(
      animation: simulationSession,
      builder: (context, _) => Container(
        color: theme.backgroundColor,
        child: Column(
          children: [
            AppBarIshBar(board: simulationSession.board),
            ProgressIndicator(progress: simulationSession.progress),
            SizedBox(height: 14),
            Board(
              board: simulationSession.board,
              onPressed: () {
                simulationSession.lockStartingSimulation();

                Navigator.of(context)
                    .push(BoardSettingDialogRoute())
                    .whenComplete(
                        () => simulationSession.unlockStartingSimulation());

                Analytics.of(context).logEvent(
                  name: "open_board_select_dialog",
                );
              },
            ),
            ErrorMessage(error: simulationSession.error),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PlayerList(
                      playerHandSettings: simulationSession.playerHandSettings,
                      results: simulationSession.results,
                      onItemPressed: (index) {
                        simulationSession.lockStartingSimulation();

                        Navigator.of(context)
                            .push(PlayerHandSettingDialogRoute(
                              settings: RouteSettings(
                                arguments: {"index": index},
                              ),
                            ))
                            .whenComplete(() =>
                                simulationSession.unlockStartingSimulation());

                        Analytics.of(context).logEvent(
                          name: "open_player_hand_setting_dialog",
                        );
                      },
                      onItemDismissed: (index) =>
                          simulationSession.removePlayerHandSettingAt(index),
                      onNewItemPressed: () {
                        simulationSession.addPlayerHandSetting();

                        simulationSession.lockStartingSimulation();

                        Navigator.of(context)
                            .push(PlayerHandSettingDialogRoute(
                              settings: RouteSettings(
                                arguments: {
                                  "index": simulationSession
                                          .playerHandSettings.length -
                                      1,
                                },
                              ),
                            ))
                            .whenComplete(() =>
                                simulationSession.unlockStartingSimulation());

                        Analytics.of(context).logEvent(
                          name: "open_player_hand_setting_dialog",
                        );
                      },
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
