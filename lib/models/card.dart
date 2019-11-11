import 'package:aqua/models/rank.dart';
import 'package:aqua/models/suit.dart';
import 'package:meta/meta.dart';

@immutable
class Card {
  const Card({@required this.rank, @required this.suit});

  Card.fromJson(Map<String, dynamic> json)
      : rank = json['rank'],
        suit = json['suit'];

  final Rank rank;
  final Suit suit;

  Map<String, dynamic> toJson() => {'rank': rank, 'suit': suit};

  @override
  String toString() {
    return [rank, suit].toString();
  }

  @override
  int get hashCode {
    int result = 17;

    result = 37 * result + suit.hashCode;
    result = 37 * result + rank.hashCode;

    return result;
  }

  @override
  bool operator ==(Object other) =>
      other is Card && other.rank == rank && other.suit == suit;

  bool operator <(Card other) {
    if (this == other) return false;

    return compareSuit(suit, other.suit) < 0 || rank < other.rank;
  }

  bool operator >(Card other) {
    if (this == other) return false;

    return !(this < other);
  }
}
