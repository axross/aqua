import "package:aqua/src/models/hand_range_simulation_result.dart";
import "package:aqua/src/models/simulation.dart";
import "package:aqua/src/services/simulation_isolate_service.dart";
import "package:aqua/src/view_models/hand_range_draft.dart";
import "package:aqua/src/view_models/hand_range_draft_list.dart";
import "package:flutter/foundation.dart";
import "package:poker/poker.dart";

class SimulationSession extends ChangeNotifier {
  SimulationSession.initial({
    this.onStartSimulation,
    this.onFinishSimulation,
  })  : _communityCards = {},
        _handRanges = HandRangeDraftList.empty(),
        _results = [] {
    _handRanges.addListener(() {
      _clearResults();
      _enqueueSimulation();
      notifyListeners();
    });
  }

  SimulationSession.from(
    Simulation simulation, {
    this.onStartSimulation,
    this.onFinishSimulation,
  })  : _communityCards = simulation.communityCards,
        _handRanges = HandRangeDraftList.of(simulation.handRanges
            .map((hr) => HandRangeDraft.fromHandRange(hr))),
        _results = simulation.results {
    _handRanges.addListener(() {
      _clearResults();
      _enqueueSimulation();
      notifyListeners();
    });

    for (final handRange in _handRanges) {
      handRange.addListener(() {
        _clearResults();
        _enqueueSimulation();
        notifyListeners();
      });
    }
  }

  final void Function(
    Set<Card> communityCards,
    List<HandRange> handRanges,
  ) onStartSimulation;

  final void Function(Simulation simulation) onFinishSimulation;

  HandRangeDraftList _handRanges;

  Set<Card> _communityCards;

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

  List<HandRangeSimulationResult> _results;

  List<HandRangeSimulationResult> get results => _results;

  bool _hasPossibleMatchup = true;

  get hasPossibleMatchup => _hasPossibleMatchup;

  SimulationIsolateService _simulationIsolateService;

  void _clearResults() {
    _results = [];
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

    notifyListeners();

    final simulationIsolateService = SimulationIsolateService();

    _simulationIsolateService = simulationIsolateService;

    await simulationIsolateService.initialize();

    if (onStartSimulation != null) {
      onStartSimulation(communityCards, handRanges);
    }

    final timesToSimulate = 100000;

    simulationIsolateService
      ..onProgress.listen(
        (simulation) {
          _hasPossibleMatchup = true;
          _results = simulation.results;

          notifyListeners();

          if (simulation.timesSimulated == timesToSimulate) {
            simulationIsolateService.dispose();
            _simulationIsolateService = null;

            if (onFinishSimulation != null) {
              onFinishSimulation(simulation);
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
        times: timesToSimulate,
      );
  }
}
