import 'package:flutter/widgets.dart';
import "package:poker/poker.dart";

class PlayerHandSetting extends ChangeNotifier {
  PlayerHandSetting({
    @required PlayerHandSettingType type,
    List<NullableCardPair> holeCardPairs,
    Set<HandRangePart> handRange,
  })  : _type = type,
        _holeCardPairs = holeCardPairs,
        _handRange = handRange;

  PlayerHandSetting.fromHandRange(Iterable<HandRangePart> handRange)
      : _handRange = handRange,
        _type = PlayerHandSettingType.handRange;

  PlayerHandSetting.emptyHoleCards() : _type = PlayerHandSettingType.holeCards;

  PlayerHandSetting.emptyHandRange() : _type = PlayerHandSettingType.handRange;

  PlayerHandSettingType _type = PlayerHandSettingType.mixed;

  PlayerHandSettingType get type => _type;

  set type(PlayerHandSettingType type) {
    _type = type;

    if (type == PlayerHandSettingType.handRange) {
      _holeCardPairs = [NullableCardPair(null, null)];
    }

    notifyListeners();
  }

  /// The hole card pairs that this player hand setting holds.
  /// Its length should be always >=1.
  List<NullableCardPair> _holeCardPairs = [NullableCardPair(null, null)];

  /// Don't change the return list itself.
  List<NullableCardPair> get holeCardPairs => _holeCardPairs;

  set holeCardPairs(List<NullableCardPair> holeCardPairs) {
    assert(holeCardPairs.isNotEmpty);

    _holeCardPairs = holeCardPairs;

    notifyListeners();
  }

  Set<HandRangePart> _handRange = {};

  /// Don't change the return set itself.
  Set<HandRangePart> get handRange => _handRange;

  set handRange(Set<HandRangePart> handRange) {
    _handRange = handRange;

    notifyListeners();
  }

  // ignore: missing_return
  Set<CardPairCombinationsGeneratable> get components {
    switch (type) {
      case PlayerHandSettingType.holeCards:
        return holeCardComponents;
      case PlayerHandSettingType.handRange:
        return handRangeComponents;
      case PlayerHandSettingType.mixed:
        return {...handRangeComponents, ...holeCardComponents};
    }
  }

  Set<CardPair> get cardPairCombinations =>
      {...holeCardPairCombinations, ...handRangeCardPairCombinations};

  Set<CardPairCombinationsGeneratable> get holeCardComponents => _holeCardPairs
      .where((pair) => pair.isComplete)
      .map((pair) => HoleCardPair(pair[0], pair[1]))
      .toSet();

  Set<CardPair> get holeCardPairCombinations => holeCardComponents.fold(
      <CardPair>{},
      (combinations, component) =>
          combinations..addAll(component.cardPairCombinations));

  Set<CardPairCombinationsGeneratable> get handRangeComponents => _handRange;

  Set<CardPair> get handRangeCardPairCombinations => handRangeComponents.fold(
      <CardPair>{},
      (combinations, component) =>
          combinations..addAll(component.cardPairCombinations));

  bool get isEmpty => components.isEmpty;

  // Set<CardPair> get cardPairCombinations => components.fold(<CardPair>{},
  // (combs, component) => combs..addAll(component.cardPairCombinations));
}

enum PlayerHandSettingType {
  holeCards,
  handRange,
  mixed,
}

// @immutable
// class PlayerHandSettingSnapshot {
//   PlayerHandSettingSnapshot._(this.components);

//   final Set<CardPairCombinationsGeneratable> components;
// }

@immutable
class NullableCardPair {
  const NullableCardPair(this._a, this._b);

  final Card _a;

  final Card _b;

  bool get isComplete => _a != null && _b != null;

  @override
  String toString() => "$_a$_b";

  @override
  int get hashCode {
    int result = 17;

    result = 37 * result + _a.hashCode;
    result = 37 * result + _b.hashCode;

    return result;
  }

  /// Returns one of card by the given index.
  operator [](int index) {
    assert(index == 0 || index == 1, "index should 0 or 1.");

    if (index == 0) return _a;
    if (index == 1) return _b;
  }

  @override
  operator ==(Object other) =>
      other is NullableCardPair && other._a == _a && other._b == _b;
}
