import "package:aqua/src/view_models/simulation_session.dart";
import "package:flutter/widgets.dart";

class CurrentSimulationSession extends InheritedWidget {
  CurrentSimulationSession({
    @required this.simulationSession,
    Widget child,
    Key key,
  })  : assert(simulationSession != null),
        super(key: key, child: child);

  final SimulationSession simulationSession;

  @override
  bool updateShouldNotify(CurrentSimulationSession old) =>
      simulationSession != old.simulationSession;

  static SimulationSession of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<CurrentSimulationSession>()
      .simulationSession;
}
