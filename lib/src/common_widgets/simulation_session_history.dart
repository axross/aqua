// import 'package:aqua/src/models/simulation_snapshot.dart';
// import "package:flutter/widgets.dart";
// import 'package:shared_preferences/shared_preferences.dart';

// class SimulationHistory extends InheritedWidget {
//   SimulationHistory({Widget child, Key key})
//       : assert(history != null),
//         history = SimulationHistoryData(),
//         super(key: key, child: child);

//   final SimulationHistoryData history;

//   @override
//   bool updateShouldNotify(SimulationHistory old) => history != old.history;

//   static SimulationHistoryData of(BuildContext context) =>
//       context.dependOnInheritedWidgetOfExactType<SimulationHistory>().history;
// }

// class SimulationHistoryData extends ChangeNotifier {
//   SimulationHistoryData();

//   SharedPreferences preferences;

//   List<SimulationSnapshot> _histories;

//   bool _isLoaded = false;

//   get isLoaded => _isLoaded;

//   List<SimulationSnapshot> get histories => _histories;

//   pushHistory(SimulationSnapshot snapshot) {
//     _histories.add(snapshot);

//     preferences.setStringList(
//         "simulationHistories", _histories.map((_) {}).toList());

//     notifyListeners();
//   }

//   Future<void> initialize() async {
//     preferences = await SharedPreferences.getInstance();

//     if (!preferences.containsKey("simulationHistories")) {
//       await preferences.setStringList("simulationHistories", []);
//     }

//     _histories = preferences.getStringList("simulationHistories");
//     _isLoaded = true;

//     notifyListeners();
//   }
// }
