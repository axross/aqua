import "package:meta/meta.dart";
import "package:poker/poker.dart";

@immutable
class NullableCardPair {
  const NullableCardPair(this._a, this._b);

  const NullableCardPair.empty()
      : _a = null,
        _b = null;

  final Card _a;

  final Card _b;

  bool get isComplete => _a != null && _b != null;

  NullableCardPair copyWith(Card a, Card b) =>
      NullableCardPair(a ?? _a, b ?? _b);

  @override
  String toString() =>
      "NullableCardPair(${_a == null ? "null" : _a.chars}, ${_b == null ? "null" : _b.chars})";

  @override
  int get hashCode {
    int result = 17;

    result = 37 * result + _a.hashCode;
    result = 37 * result + _b.hashCode;

    return result;
  }

  @override
  operator ==(Object other) =>
      other is NullableCardPair && other._a == _a && other._b == _b;

  /// Returns one of card by the given index.
  operator [](index) {
    assert(index == 0 || index == 1);

    return index == 0 ? _a : _b;
  }
}
