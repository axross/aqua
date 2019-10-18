class Card {
  final Rank rank;
  final Suit suit;

  @override
  String toString() {
    return [rank, suit].toString();
  }

  @override
  int get hashCode => suit.index * 13 + rank.index;

  @override
  bool operator ==(Object other) =>
      other is Card && other.rank == rank && other.suit == suit;

  bool operator <(Card other) {
    if (this == other) return false;

    return suit.index < other.suit.index || rank.index < other.rank.index;
  }

  bool operator >(Card other) {
    if (this == other) return false;

    return !(this < other);
  }

  Card({this.rank, this.suit});
}

enum Rank {
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
}

enum Suit {
  spade,
  heart,
  diamond,
  club,
}
