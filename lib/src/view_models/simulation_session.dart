import "package:aqua/src/models/simulation_snapshot.dart";
import "package:aqua/src/services/simulation_isolate_service.dart";
import "package:aqua/src/view_models/hand_range_draft_list.dart";
import "package:flutter/foundation.dart";
import "package:poker/poker.dart";

class SimulationSession extends ChangeNotifier {
  SimulationSession.initial({
    this.onStartSimulation,
    this.onFinishSimulation,
  }) : _handRanges = HandRangeDraftList.empty() {
    _handRanges.addListener(() {
      _clearResults();
      _enqueueSimulation();
      notifyListeners();
    });
  }

  final VoidCallback onStartSimulation;

  final void Function(SimulationSnapshot snapshot) onFinishSimulation;

  HandRangeDraftList _handRanges;

  Set<Card> _communityCards = {};

  Set<Card> get communityCards => _communityCards;

  set communityCards(Set<Card> communityCards) {
    if (communityCards.containsAll(_communityCards) &&
        _communityCards.containsAll(communityCards)) {
      return;
    }

    _communityCards = communityCards;

    _clearResults();
    _enqueueSimulation();
    notifyListeners();
  }

  HandRangeDraftList get handRanges => _handRanges;

  List<PlayerSimulationOverallResult> _results = [];

  get results => _results;

  bool _hasPossibleMatchup = true;

  get hasPossibleMatchup => _hasPossibleMatchup;

  double _progress = 0;

  get progress => _progress;

  SimulationIsolateService _simulationIsolateService;

  void _clearResults() {
    _results = [];
    _progress = 0;
  }

  void _enqueueSimulation() async {
    if (_handRanges.length <= 1) return;
    if (_handRanges.hasIncomplete) return;

    final communityCards = _communityCards.toSet();
    final handRanges = _handRanges.map((hr) => hr.toHandRange()).toList();

    if (_simulationIsolateService != null) {
      _simulationIsolateService.dispose();
      _simulationIsolateService = null;

      if (onFinishSimulation != null) {
        onFinishSimulation(null);
      }
    }

    _results = [];
    _progress = 0;

    notifyListeners();

    final simulationIsolateService = SimulationIsolateService();

    _simulationIsolateService = simulationIsolateService;

    await simulationIsolateService.initialize();

    if (onStartSimulation != null) {
      onStartSimulation();
    }

    simulationIsolateService
      ..onProgress.listen(
        (details) {
          _hasPossibleMatchup = true;
          _results = details.results;
          _progress = details.timesSimulated / details.timesWillBeSimulated;

          notifyListeners();

          if (details.timesSimulated == details.timesWillBeSimulated) {
            simulationIsolateService.dispose();
            _simulationIsolateService = null;

            if (onFinishSimulation != null) {
              onFinishSimulation(SimulationSnapshot(
                handRanges: handRanges,
                communityCards: communityCards,
                results: _results,
              ));
            }
          }
        },
        onError: (error) {
          simulationIsolateService.dispose();
          _simulationIsolateService = null;

          if (error is NoPossibleMatchupException) {
            debugPrint("simulation canceled: ${error.runtimeType}");

            _hasPossibleMatchup = false;

            notifyListeners();

            return;
          }

          throw error;
        },
      )
      ..requestSimulation(
        handRanges: handRanges,
        communityCards: communityCards,
      );
  }
}
