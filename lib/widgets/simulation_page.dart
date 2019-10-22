import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:provider/provider.dart';
import '../view_models/simulation_session.dart' show SimulationSession;
import './player_list_view.dart' show PlayerListView;

class SimulationPage extends StatefulWidget {
  SimulationPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
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
          appBar: AppBar(
            title: Text(widget.title),
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
