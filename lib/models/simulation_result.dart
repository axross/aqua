import 'package:aqua/models/hand_type.dart';
import 'package:meta/meta.dart';

@immutable
class SimulationResult {
  SimulationResult.empty()
      : _resultEachHandType = {
          HandType.high: SimulationResultEachHandType.zero(),
          HandType.pair: SimulationResultEachHandType.zero(),
          HandType.twoPairs: SimulationResultEachHandType.zero(),
          HandType.threeOfAKind: SimulationResultEachHandType.zero(),
          HandType.straight: SimulationResultEachHandType.zero(),
          HandType.flush: SimulationResultEachHandType.zero(),
          HandType.fullHouse: SimulationResultEachHandType.zero(),
          HandType.fourOfAKind: SimulationResultEachHandType.zero(),
          HandType.straightFlush: SimulationResultEachHandType.zero(),
        },
        _totalGames = 0,
        _totalWin = 0,
        _totalLose = 0,
        _totalEven = 0;

  SimulationResult.fromMap(this._resultEachHandType)
      : _totalGames = _resultEachHandType.values.fold(0,
            (total, result) => total + result.win + result.lose + result.even),
        _totalWin = _resultEachHandType.values
            .fold(0, (total, result) => total + result.win),
        _totalLose = _resultEachHandType.values
            .fold(0, (total, result) => total + result.lose),
        _totalEven = _resultEachHandType.values
            .fold(0, (total, result) => total + result.even);

  final Map<HandType, SimulationResultEachHandType> _resultEachHandType;

  final int _totalGames;

  final int _totalWin;

  final int _totalLose;

  final int _totalEven;

  int get totalGames => _totalGames;

  int get totalWin => _totalWin;

  int get totalLose => _totalLose;

  int get totalEven => _totalEven;

  double get winRate =>
      _totalGames == 0 ? 0.0 : (_totalWin + _totalEven) / _totalGames;

  Iterable<MapEntry<HandType, SimulationResultEachHandType>> get entries =>
      _resultEachHandType.entries;

  SimulationResultEachHandType operator [](HandType handType) =>
      _resultEachHandType[handType];

  SimulationResult operator +(SimulationResult other) =>
      SimulationResult.fromMap({
        HandType.high: SimulationResultEachHandType(
          win: this[HandType.high].win + other[HandType.high].win,
          lose: this[HandType.high].lose + other[HandType.high].lose,
          even: this[HandType.high].even + other[HandType.high].even,
        ),
        HandType.pair: SimulationResultEachHandType(
          win: this[HandType.pair].win + other[HandType.pair].win,
          lose: this[HandType.pair].lose + other[HandType.pair].lose,
          even: this[HandType.pair].even + other[HandType.pair].even,
        ),
        HandType.twoPairs: SimulationResultEachHandType(
          win: this[HandType.twoPairs].win + other[HandType.twoPairs].win,
          lose: this[HandType.twoPairs].lose + other[HandType.twoPairs].lose,
          even: this[HandType.twoPairs].even + other[HandType.twoPairs].even,
        ),
        HandType.threeOfAKind: SimulationResultEachHandType(
          win: this[HandType.threeOfAKind].win +
              other[HandType.threeOfAKind].win,
          lose: this[HandType.threeOfAKind].lose +
              other[HandType.threeOfAKind].lose,
          even: this[HandType.threeOfAKind].even +
              other[HandType.threeOfAKind].even,
        ),
        HandType.straight: SimulationResultEachHandType(
          win: this[HandType.straight].win + other[HandType.straight].win,
          lose: this[HandType.straight].lose + other[HandType.straight].lose,
          even: this[HandType.straight].even + other[HandType.straight].even,
        ),
        HandType.flush: SimulationResultEachHandType(
          win: this[HandType.flush].win + other[HandType.flush].win,
          lose: this[HandType.flush].lose + other[HandType.flush].lose,
          even: this[HandType.flush].even + other[HandType.flush].even,
        ),
        HandType.fullHouse: SimulationResultEachHandType(
          win: this[HandType.fullHouse].win + other[HandType.fullHouse].win,
          lose: this[HandType.fullHouse].lose + other[HandType.fullHouse].lose,
          even: this[HandType.fullHouse].even + other[HandType.fullHouse].even,
        ),
        HandType.fourOfAKind: SimulationResultEachHandType(
          win: this[HandType.fourOfAKind].win + other[HandType.fourOfAKind].win,
          lose: this[HandType.fourOfAKind].lose +
              other[HandType.fourOfAKind].lose,
          even: this[HandType.fourOfAKind].even +
              other[HandType.fourOfAKind].even,
        ),
        HandType.straightFlush: SimulationResultEachHandType(
          win: this[HandType.straightFlush].win +
              other[HandType.straightFlush].win,
          lose: this[HandType.straightFlush].lose +
              other[HandType.straightFlush].lose,
          even: this[HandType.straightFlush].even +
              other[HandType.straightFlush].even,
        ),
      });
}

@immutable
class SimulationResultEachHandType {
  SimulationResultEachHandType(
      {@required this.win, @required this.lose, @required this.even})
      : assert(win != null),
        assert(lose != null),
        assert(even != null);

  SimulationResultEachHandType.zero()
      : win = 0,
        lose = 0,
        even = 0;

  final int win;
  final int lose;
  final int even;

  SimulationResultEachHandType copyWith({int win, int lose, int even}) =>
      SimulationResultEachHandType(
        win: win ?? this.win,
        lose: lose ?? this.lose,
        even: even ?? this.even,
      );
}
