import 'package:aqua/models/card.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/simulation_result.dart';
import 'package:aqua/models/simulator.dart';
import 'package:aqua/services/simulation_isolate_service.dart';
import 'package:flutter/foundation.dart';

class SimulationSession {
  SimulationSession.initial()
      : board = ValueNotifier(<Card>[null, null, null, null, null]),
        playerHandSettings = ValueNotifier([]),
        results = ValueNotifier([]),
        error = ValueNotifier(null) {
    board.addListener(_onSituationChanged);
    playerHandSettings.addListener(_onSituationChanged);
  }

  final ValueNotifier<List<Card>> board;

  final ValueNotifier<List<PlayerHandSetting>> playerHandSettings;

  final ValueNotifier<List<SimulationResult>> results;

  final ValueNotifier<SimulationCancelException> error;

  SimulationIsolateService _simulationIsolateService;

  void _onSituationChanged() async {
    if (_simulationIsolateService != null) {
      _simulationIsolateService.dispose();
      _simulationIsolateService = null;
    }

    results.value = [];

    _simulationIsolateService = SimulationIsolateService();

    await _simulationIsolateService.initialize();

    _simulationIsolateService
      ..onSimulated.listen(
        (data) {
          error.value = null;
          results.value = data;
        },
        onError: (error) {
          if (error is SimulationCancelException) {
            debugPrint("simulation canceled: ${error.runtimeType}");

            this.error.value = error;

            return;
          }

          throw error;
        },
      )
      ..requestSimulation(
        playerHandSettings: playerHandSettings.value,
        board: board.value,
      );
  }
}
