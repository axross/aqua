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
  SimulationSession _simulationSession;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final theme = AquaTheme.of(context);

    setSystemUIOverlayStyle(
      topColor: theme.dimBackgroundColor,
      bottomColor: theme.backgroundColor,
    );

    if (_simulationSession == null) {
      _simulationSession = SimulationSessionProvider.of(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return AnimatedBuilder(
      animation: _simulationSession,
      builder: (context, _) => Container(
        color: theme.backgroundColor,
        child: Column(
          children: [
            AppBarIshBar(board: _simulationSession.board),
            ProgressIndicator(progress: _simulationSession.progress),
            SizedBox(height: 14),
            Board(
              board: _simulationSession.board,
              onPressed: () {
                _simulationSession.lockStartingSimulation();

                Navigator.of(context)
                    .push(BoardSettingDialogRoute())
                    .whenComplete(
                        () => _simulationSession.unlockStartingSimulation());

                Analytics.of(context).logEvent(
                  name: "open_board_select_dialog",
                );
              },
            ),
            ErrorMessage(error: _simulationSession.error),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PlayerList(
                      playerHandSettings: _simulationSession.playerHandSettings,
                      results: _simulationSession.results,
                      onItemPressed: (index) {
                        _simulationSession.lockStartingSimulation();

                        Navigator.of(context)
                            .push(PlayerHandSettingDialogRoute(
                              settings: RouteSettings(
                                arguments: {"index": index},
                              ),
                            ))
                            .whenComplete(() =>
                                _simulationSession.unlockStartingSimulation());

                        Analytics.of(context).logEvent(
                          name: "open_player_hand_setting_dialog",
                        );
                      },
                      onItemDismissed: (index) =>
                          _simulationSession.removePlayerHandSettingAt(index),
                      onNewItemPressed: () {
                        _simulationSession.addPlayerHandSetting();

                        _simulationSession.lockStartingSimulation();

                        Navigator.of(context)
                            .push(PlayerHandSettingDialogRoute(
                              settings: RouteSettings(
                                arguments: {
                                  "index": _simulationSession
                                          .playerHandSettings.length -
                                      1,
                                },
                              ),
                            ))
                            .whenComplete(() =>
                                _simulationSession.unlockStartingSimulation());

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
