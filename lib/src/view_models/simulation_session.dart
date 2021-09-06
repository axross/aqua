import "package:aqua/app/services/flutter_isolate_evaluation_service.dart";
import "package:aqua/src/models/calculation.dart";
import "package:aqua/src/services/isolate_evaluation_service.dart";
import "package:aqua/src/view_models/hand_range_draft_list.dart";
import "package:flutter/foundation.dart";
import "package:poker/poker.dart";

class CalculationSession extends ChangeNotifier {
  CalculationSession.initial({
    this.onStartCalculation,
    this.onFinishCalculation,
  })  : _communityCards = CardSet.empty,
        _players = HandRangeDraftList.empty(),
        _result = EvaluationResult.empty(playerLength: 0) {
    _players.addListener(() {
      _clearResults();
      _enqueueCalculation();
      notifyListeners();
    });
  }

  final void Function(
    CardSet communityCards,
    List<HandRange> players,
  )? onStartCalculation;

  final void Function(Calculation? calculation)? onFinishCalculation;

  HandRangeDraftList _players;

  CardSet _communityCards;

  CardSet get communityCards => _communityCards;

  set communityCards(CardSet communityCards) {
    if (communityCards == _communityCards) {
      return;
    }

    _communityCards = communityCards;

    _clearResults();
    _enqueueCalculation();
    notifyListeners();
  }

  HandRangeDraftList get players => _players;

  EvaluationResult _result;

  EvaluationResult get result => _result;

  bool _hasPossibleMatchup = true;

  get hasPossibleMatchup => _hasPossibleMatchup;

  IsolateEvaluationService? _isolateEvaluationService;

  void _clearResults() {
    _result = EvaluationResult.empty(playerLength: players.length);
  }

  void _enqueueCalculation() async {
    if (_players.length <= 1) return;
    if (_players.hasIncomplete) return;

    final players = _players.map((hr) => hr.toHandRange()).toList();

    if (_isolateEvaluationService != null) {
      _isolateEvaluationService!.dispose();
      _isolateEvaluationService = null;

      if (onFinishCalculation != null) {
        onFinishCalculation!(null);
      }
    }

    _result = EvaluationResult.empty(playerLength: _players.length);

    notifyListeners();

    final isolateEvaluationService = FlutterIsolateEvaluationService();

    _isolateEvaluationService = isolateEvaluationService;

    await isolateEvaluationService.initialize();

    if (onStartCalculation != null) {
      onStartCalculation!(communityCards, players);
    }

    final timesToSimulate = 200000;

    isolateEvaluationService
      ..onProgress.listen(
        (calculation) {
          _hasPossibleMatchup = true;
          _result = calculation.result;

          notifyListeners();

          if (calculation.result.tries == timesToSimulate) {
            isolateEvaluationService.dispose();
            _isolateEvaluationService = null;

            if (onFinishCalculation != null) {
              onFinishCalculation!(calculation);
            }
          }
        },
        onError: (error) {
          isolateEvaluationService.dispose();
          _isolateEvaluationService = null;

          // if (error is NoPossibleMatchupException) {
          //   debugPrint("calculation canceled: ${error.runtimeType}");

          _hasPossibleMatchup = false;

          notifyListeners();

          //   return;
          // }

          throw error;
        },
      )
      ..requestEvaluation(
        players: players,
        communityCards: communityCards,
        times: timesToSimulate,
      );
  }
}
