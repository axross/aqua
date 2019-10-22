import 'dart:collection' show IterableMixin;
import 'package:meta/meta.dart' show immutable;
import './card.dart' show Card;

@immutable
class CardPair with IterableMixin<Card> {
  CardPair(this._a, this._b);

  CardPair.fromJson(List<Map<String, dynamic>> json)
      : _a = Card.fromJson(json[0]),
        _b = Card.fromJson(json[1]);

  final Card _a;
  final Card _b;

  List<Map<String, dynamic>> toJson() => [_a.toJson(), _b.toJson()];

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
}