abstract class Suit {
  int compareTo(Suit other);

  String toString();

  bool operator <(Suit other);

  bool operator >(Suit other);

  static const spade = _Suit(0);
  static const heart = _Suit(1);
  static const diamond = _Suit(2);
  static const club = _Suit(3);

  static const values = [
    Suit.spade,
    Suit.heart,
    Suit.diamond,
    Suit.club,
  ];
}

class _Suit implements Suit {
  const _Suit(this._index);

  final int _index;

  @override
  int get hashCode => _index.hashCode;

  @override
  int compareTo(Suit other) => _index - (other as _Suit)._index;

  @override
  String toString() {
    switch (this._index) {
      case 0:
        return "s";
      case 1:
        return "h";
      case 2:
        return "d";
      case 3:
        return "c";
    }

    assert(false, "unreachable here");

    return "Invalid";
  }

  bool operator ==(Object other) => other is _Suit && other._index == _index;

  bool operator <(Suit other) => compareTo(other) <= -1;

  bool operator >(Suit other) => compareTo(other) >= 1;
}
