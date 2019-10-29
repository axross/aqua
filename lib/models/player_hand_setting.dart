import 'package:aqua/models/card.dart';
import 'package:aqua/models/card_pair.dart';
import 'package:aqua/models/hand_range_part.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PlayerHandSetting {
  Set<CardPair> get cardPairCombinations;
}

@immutable
class PlayerHoleCards implements PlayerHandSetting {
  PlayerHoleCards({Card left, Card right})
      : _left = left,
        _right = right;

  final Card _left;
  final Card _right;

  Set<CardPair> get cardPairCombinations =>
      _left != null && _right != null ? {CardPair(_left, _right)} : {};

  PlayerHoleCards copyWith({Card left, Card right}) =>
      PlayerHoleCards(left: left ?? _left, right: right ?? _right);

  Card operator [](int index) {
    assert(index == 0 || index == 1);

    return index == 0 ? _left : _right;
  }
}

@immutable
class PlayerHandRange implements PlayerHandSetting {
  PlayerHandRange(this._handRange);

  PlayerHandRange.empty() : _handRange = Set();

  final Set<HandRangePart> _handRange;

  Set<CardPair> get cardPairCombinations => _handRange.fold(
      Set<CardPair>(),
      (cardPairSet, handRangePart) =>
          cardPairSet..addAll(handRangePart.combinations));

  Set<HandRangePart> get handRange => _handRange;

  PlayerHandRange copyWith(Set<HandRangePart> handRange) =>
      PlayerHandRange(handRange);
}
