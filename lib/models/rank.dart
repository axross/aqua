abstract class Rank {
  int compareTo(Rank other);

  int compareStrongnessTo(Rank other);

  int toInt();

  String toString();

  bool operator <(Rank other);

  bool operator >(Rank other);

  static const ace = _Rank(0);
  static const two = _Rank(1);
  static const three = _Rank(2);
  static const four = _Rank(3);
  static const five = _Rank(4);
  static const six = _Rank(5);
  static const seven = _Rank(6);
  static const eight = _Rank(7);
  static const nine = _Rank(8);
  static const ten = _Rank(9);
  static const jack = _Rank(10);
  static const queen = _Rank(11);
  static const king = _Rank(12);

  static const values = [
    Rank.ace,
    Rank.two,
    Rank.three,
    Rank.four,
    Rank.five,
    Rank.six,
    Rank.seven,
    Rank.eight,
    Rank.nine,
    Rank.ten,
    Rank.jack,
    Rank.queen,
    Rank.king,
  ];

  static const valuesInStrongnessOrder = [
    Rank.ace,
    Rank.king,
    Rank.queen,
    Rank.jack,
    Rank.ten,
    Rank.nine,
    Rank.eight,
    Rank.seven,
    Rank.six,
    Rank.five,
    Rank.four,
    Rank.three,
    Rank.two,
  ];
}

class _Rank implements Rank {
  const _Rank(this._index);

  final int _index;

  @override
  int get hashCode => _index.hashCode;

  @override
  int compareTo(Rank other) => _index - (other as _Rank)._index;

  @override
  int compareStrongnessTo(Rank other) {
    final strongness = this == Rank.ace ? 13 : _index;
    final otherStrongness = other == Rank.ace ? 13 : (other as _Rank)._index;

    return strongness - otherStrongness;
  }

  @override
  int toInt() => this._index;

  @override
  String toString() {
    switch (this._index) {
      case 0:
        return "A";
      case 1:
        return "2";
      case 2:
        return "3";
      case 3:
        return "4";
      case 4:
        return "5";
      case 5:
        return "6";
      case 6:
        return "7";
      case 7:
        return "8";
      case 8:
        return "9";
      case 9:
        return "T";
      case 10:
        return "J";
      case 11:
        return "Q";
      case 12:
        return "K";
    }

    assert(false, "unreachable here");

    return "Invalid";
  }

  bool operator ==(Object other) => other is _Rank && other._index == _index;

  bool operator <(Rank other) => compareTo(other) <= -1;

  bool operator >(Rank other) => compareTo(other) >= 1;
}
