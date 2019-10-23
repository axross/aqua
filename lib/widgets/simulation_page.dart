import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:provider/provider.dart';
import '../view_models/simulation_session.dart' show SimulationSession;
import './board.dart' show Board;
import './player_list_view.dart' show PlayerListView;
import './board_select_dialog_route.dart' show BoardSelectDialogRoute;

class SimulationPage extends StatefulWidget {
  SimulationPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ValueNotifier<SimulationSession> _simulationSession;

  @override
  void initState() {
    super.initState();

    _simulationSession = ValueNotifier(SimulationSession.initial());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SimulationSession>(
      valueListenable: _simulationSession,
      builder: (context, session, __) => AnimatedBuilder(
        animation: session.handSettings,
        builder: (context, _) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Win Rate Calculation"),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(BoardSelectDialogRoute(
                  simulationSession: session,
                )),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    height: 72,
                    child: ValueListenableBuilder(
                      valueListenable: session.board,
                      builder: (context, board, _) => Board(cards: board),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Provider.value(
            value: session,
            child: PlayerListView(),
          ),
          floatingActionButton: session.handSettings.isFull
              ? null
              : FloatingActionButton.extended(
                  onPressed: () {
                    if (session.handSettings.isFull) return;

                    _simulationSession.value.handSettings.addEmpty();

                    // _scaffoldKey.currentState.showSnackBar(SnackBar(
                    //   content: Text("Delete something to calculate"),
                    // ));
                  },
                  tooltip: 'Add Player',
                  icon: Icon(Icons.add),
                  label: Text("Add Player"),
                ),
        ),
      ),
    );
  }
}
