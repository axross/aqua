import 'dart:collection';
import './card.dart' show Card;

class CardPair with IterableMixin<Card> {
  final Card _a;
  final Card _b;

  @override
  Iterator<Card> get iterator => {_a, _b}.iterator;

  @override
  int get hashCode => _a.hashCode * 51 + _b.hashCode;

  @override
  bool operator ==(Object other) =>
      other is CardPair && other.contains(_a) && other.contains(_b);

  Card operator [](int index) {
    assert(index == 0 || index == 1);

    return index == 0 ? _a : _b;
  }

  CardPair(this._a, this._b);
}
