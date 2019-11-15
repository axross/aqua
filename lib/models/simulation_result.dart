import 'package:aqua/models/hand_type.dart';
import 'package:meta/meta.dart';

@immutable
class SimulationResult {
  SimulationResult.empty()
      : _resultEachHandType = const {
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
        _totalDraw = 0;

  SimulationResult.fromMap(this._resultEachHandType)
      : _totalGames = _resultEachHandType.values.fold(0,
            (total, result) => total + result.win + result.lose + result.draw),
        _totalWin = _resultEachHandType.values
            .fold(0, (total, result) => total + result.win),
        _totalLose = _resultEachHandType.values
            .fold(0, (total, result) => total + result.lose),
        _totalDraw = _resultEachHandType.values
            .fold(0, (total, result) => total + result.draw);

  final Map<HandType, SimulationResultEachHandType> _resultEachHandType;

  final int _totalGames;

  final int _totalWin;

  final int _totalLose;

  final int _totalDraw;

  int get totalGames => _totalGames;

  int get totalWin => _totalWin;

  int get totalLose => _totalLose;

  int get totalDraw => _totalDraw;

  double get winRate => _totalGames == 0 ? 0.0 : _totalWin / _totalGames;

  double get drawRate => _totalGames == 0 ? 0.0 : _totalDraw / _totalGames;

  Iterable<MapEntry<HandType, SimulationResultEachHandType>> get entries =>
      _resultEachHandType.entries;

  SimulationResultEachHandType operator [](HandType handType) =>
      _resultEachHandType[handType];

  SimulationResult operator +(SimulationResult other) =>
      SimulationResult.fromMap({
        HandType.high: SimulationResultEachHandType(
          win: this[HandType.high].win + other[HandType.high].win,
          lose: this[HandType.high].lose + other[HandType.high].lose,
          draw: this[HandType.high].draw + other[HandType.high].draw,
        ),
        HandType.pair: SimulationResultEachHandType(
          win: this[HandType.pair].win + other[HandType.pair].win,
          lose: this[HandType.pair].lose + other[HandType.pair].lose,
          draw: this[HandType.pair].draw + other[HandType.pair].draw,
        ),
        HandType.twoPairs: SimulationResultEachHandType(
          win: this[HandType.twoPairs].win + other[HandType.twoPairs].win,
          lose: this[HandType.twoPairs].lose + other[HandType.twoPairs].lose,
          draw: this[HandType.twoPairs].draw + other[HandType.twoPairs].draw,
        ),
        HandType.threeOfAKind: SimulationResultEachHandType(
          win: this[HandType.threeOfAKind].win +
              other[HandType.threeOfAKind].win,
          lose: this[HandType.threeOfAKind].lose +
              other[HandType.threeOfAKind].lose,
          draw: this[HandType.threeOfAKind].draw +
              other[HandType.threeOfAKind].draw,
        ),
        HandType.straight: SimulationResultEachHandType(
          win: this[HandType.straight].win + other[HandType.straight].win,
          lose: this[HandType.straight].lose + other[HandType.straight].lose,
          draw: this[HandType.straight].draw + other[HandType.straight].draw,
        ),
        HandType.flush: SimulationResultEachHandType(
          win: this[HandType.flush].win + other[HandType.flush].win,
          lose: this[HandType.flush].lose + other[HandType.flush].lose,
          draw: this[HandType.flush].draw + other[HandType.flush].draw,
        ),
        HandType.fullHouse: SimulationResultEachHandType(
          win: this[HandType.fullHouse].win + other[HandType.fullHouse].win,
          lose: this[HandType.fullHouse].lose + other[HandType.fullHouse].lose,
          draw: this[HandType.fullHouse].draw + other[HandType.fullHouse].draw,
        ),
        HandType.fourOfAKind: SimulationResultEachHandType(
          win: this[HandType.fourOfAKind].win + other[HandType.fourOfAKind].win,
          lose: this[HandType.fourOfAKind].lose +
              other[HandType.fourOfAKind].lose,
          draw: this[HandType.fourOfAKind].draw +
              other[HandType.fourOfAKind].draw,
        ),
        HandType.straightFlush: SimulationResultEachHandType(
          win: this[HandType.straightFlush].win +
              other[HandType.straightFlush].win,
          lose: this[HandType.straightFlush].lose +
              other[HandType.straightFlush].lose,
          draw: this[HandType.straightFlush].draw +
              other[HandType.straightFlush].draw,
        ),
      });
}

@immutable
class SimulationResultEachHandType {
  const SimulationResultEachHandType(
      {@required this.win, @required this.lose, @required this.draw})
      : assert(win != null),
        assert(lose != null),
        assert(draw != null);

  const SimulationResultEachHandType.zero()
      : win = 0,
        lose = 0,
        draw = 0;

  final int win;
  final int lose;
  final int draw;

  SimulationResultEachHandType copyWith({int win, int lose, int draw}) =>
      SimulationResultEachHandType(
        win: win ?? this.win,
        lose: lose ?? this.lose,
        draw: draw ?? this.draw,
      );
}
