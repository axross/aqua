import 'package:aqua/card.dart' show Card;
import 'package:aqua/card_pair.dart' show CardPair;
import 'package:aqua/hand.dart' show Hand;

class Showdown {
  final Set<Card> board;
  final Iterable<CardPair> players;
  final Iterable<Hand> hands;

  Showdown({this.board, this.players})
      : assert(board != null),
        assert(board.length == 5),
        assert(players != null),
        assert(players.length >= 1),
        hands = players
            .map((holeCard) => Hand.bestFrom(board.union({...holeCard})));
}
