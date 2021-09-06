import "package:aqua/src/view_models/simulation_session.dart";
import "package:flutter/widgets.dart";

class CurrentSimulationSession extends InheritedWidget {
  CurrentSimulationSession({
    required this.simulationSession,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final CalculationSession simulationSession;

  @override
  bool updateShouldNotify(CurrentSimulationSession old) =>
      simulationSession != old.simulationSession;

  static CalculationSession of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<CurrentSimulationSession>()!
      .simulationSession;
}
