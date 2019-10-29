import 'package:aqua/models/card.dart';
import 'package:aqua/models/card_pair.dart';
import 'package:aqua/models/hand.dart';
import 'package:meta/meta.dart';

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
