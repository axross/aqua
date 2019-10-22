import 'package:meta/meta.dart' show immutable;
import './card.dart' show Card;
import './card_pair.dart' show CardPair;
import './hand.dart' show Hand;

@immutable
class Showdown {
  final Set<Card> board;
  final Iterable<CardPair> holeCards;
  final Iterable<Hand> hands;

  Showdown({this.board, this.holeCards})
      : assert(board != null),
        assert(board.length == 5),
        assert(holeCards != null),
        assert(holeCards.length >= 1),
        hands = holeCards
            .map((holeCard) => Hand.bestFrom(board.union({...holeCard})));
}
