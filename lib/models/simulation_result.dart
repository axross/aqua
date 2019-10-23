import './hand.dart' show HandType;

class SimulationResult {
  SimulationResult.empty({
    Map<HandType, SimulationResultEachHandType> resultEachHandType,
  })  : _resultEachHandType = resultEachHandType ??
            {
              HandType.high: SimulationResultEachHandType(),
              HandType.aPair: SimulationResultEachHandType(),
              HandType.twoPairs: SimulationResultEachHandType(),
              HandType.threeOfAKind: SimulationResultEachHandType(),
              HandType.straight: SimulationResultEachHandType(),
              HandType.flush: SimulationResultEachHandType(),
              HandType.fullhouse: SimulationResultEachHandType(),
              HandType.fourOfAKind: SimulationResultEachHandType(),
              HandType.straightFlush: SimulationResultEachHandType(),
            },
        _totalGames = 0,
        _totalWin = 0,
        _totalLose = 0,
        _totalEven = 0;

  final Map<HandType, SimulationResultEachHandType> _resultEachHandType;

  int _totalGames;

  int _totalWin;

  int _totalLose;

  int _totalEven;

  int get totalGames => _totalGames;

  int get totalWin => _totalWin;

  int get totalLose => _totalLose;

  int get totalEven => _totalEven;

  double get winRate =>
      _totalGames == 0 ? 0.0 : (_totalWin + _totalEven) / _totalGames;

  Iterable<MapEntry<HandType, SimulationResultEachHandType>> get entries =>
      _resultEachHandType.entries;

  sum(SimulationResult other) {
    for (final entry in other.entries) {
      _resultEachHandType[entry.key].win += entry.value.win;
      _resultEachHandType[entry.key].lose += entry.value.lose;
      _resultEachHandType[entry.key].even += entry.value.even;
      _totalGames += entry.value.win;
      _totalGames += entry.value.lose;
      _totalGames += entry.value.even;
      _totalWin += entry.value.win;
      _totalLose += entry.value.lose;
      _totalEven += entry.value.even;
    }
  }

  SimulationResultEachHandType operator [](HandType handType) =>
      _resultEachHandType[handType];
}

class SimulationResultEachHandType {
  SimulationResultEachHandType({int win, int lose, int even})
      : win = win ?? 0,
        lose = lose ?? 0,
        even = even ?? 0;

  int win;
  int lose;
  int even;
}
