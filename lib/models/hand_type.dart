abstract class HandType {
  int compareTo(HandType other);

  String toString();

  bool operator <(HandType other);

  bool operator >(HandType other);

  static const straightFlush = _HandType(0);
  static const fourOfAKind = _HandType(1);
  static const fullHouse = _HandType(2);
  static const flush = _HandType(3);
  static const straight = _HandType(4);
  static const threeOfAKind = _HandType(5);
  static const twoPairs = _HandType(6);
  static const pair = _HandType(7);
  static const high = _HandType(8);

  static const values = [
    HandType.straightFlush,
    HandType.fourOfAKind,
    HandType.fullHouse,
    HandType.flush,
    HandType.straight,
    HandType.threeOfAKind,
    HandType.twoPairs,
    HandType.pair,
    HandType.high,
  ];
}

class _HandType implements HandType {
  const _HandType(this._index);

  final int _index;

  @override
  int get hashCode => _index.hashCode;

  @override
  int compareTo(HandType other) => _index - (other as _HandType)._index;

  @override
  bool operator ==(Object other) =>
      other is _HandType && other._index == _index;

  @override
  bool operator <(HandType other) => compareTo(other) <= -1;

  @override
  bool operator >(HandType other) => compareTo(other) >= 1;
}
