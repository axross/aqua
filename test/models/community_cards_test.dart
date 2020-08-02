import "package:aqua/src/models/community_cards.dart";
import "package:flutter_test/flutter_test.dart";
import "package:poker/poker.dart";

void main() {
  test(
    "CommunityCards([As, Kh, Qd]) returns 3-card length CommunityCards but it actually holds 3 cards and 2 nulls",
    () {
      final communityCards = CommunityCards([
        Card(rank: Rank.ace, suit: Suit.spade),
        Card(rank: Rank.king, suit: Suit.heart),
        Card(rank: Rank.queen, suit: Suit.diamond),
      ]);

      expect(communityCards.length, equals(3));
      expect(
          communityCards.cards,
          equals([
            Card(rank: Rank.ace, suit: Suit.spade),
            Card(rank: Rank.king, suit: Suit.heart),
            Card(rank: Rank.queen, suit: Suit.diamond),
            null,
            null,
          ]));
    },
  );

  test(
    "CommunityCards([As, Kh, Qd, Jc, Ts]) equals CommunityCards([As, Kh, Qd, Jc, Ts])",
    () {
      expect(
        CommunityCards([
              Card(rank: Rank.ace, suit: Suit.spade),
              Card(rank: Rank.king, suit: Suit.heart),
              Card(rank: Rank.queen, suit: Suit.diamond),
              Card(rank: Rank.jack, suit: Suit.club),
              Card(rank: Rank.ten, suit: Suit.spade),
            ]) ==
            CommunityCards([
              Card(rank: Rank.ace, suit: Suit.spade),
              Card(rank: Rank.king, suit: Suit.heart),
              Card(rank: Rank.queen, suit: Suit.diamond),
              Card(rank: Rank.jack, suit: Suit.club),
              Card(rank: Rank.ten, suit: Suit.spade),
            ]),
        isTrue,
      );
    },
  );

  test(
    "CommunityCards([As, Kh, Qd, Jc, Ts]) doesn't equal CommunityCards([As, Kh, Qd, Jc])",
    () {
      expect(
        CommunityCards([
              Card(rank: Rank.ace, suit: Suit.spade),
              Card(rank: Rank.king, suit: Suit.heart),
              Card(rank: Rank.queen, suit: Suit.diamond),
              Card(rank: Rank.jack, suit: Suit.club),
              Card(rank: Rank.ten, suit: Suit.spade),
            ]) ==
            CommunityCards([
              Card(rank: Rank.ace, suit: Suit.spade),
              Card(rank: Rank.king, suit: Suit.heart),
              Card(rank: Rank.queen, suit: Suit.diamond),
              Card(rank: Rank.jack, suit: Suit.club),
            ]),
        isFalse,
      );
    },
  );

  test(
    "CommunityCards([As, Kh, Qd, Jc, Ts]) doesn't equal CommunityCards([As, Kh, Qd, Ts, Jc])",
    () {
      expect(
        CommunityCards([
              Card(rank: Rank.ace, suit: Suit.spade),
              Card(rank: Rank.king, suit: Suit.heart),
              Card(rank: Rank.queen, suit: Suit.diamond),
              Card(rank: Rank.jack, suit: Suit.club),
              Card(rank: Rank.ten, suit: Suit.spade),
            ]) ==
            CommunityCards([
              Card(rank: Rank.ace, suit: Suit.spade),
              Card(rank: Rank.king, suit: Suit.heart),
              Card(rank: Rank.queen, suit: Suit.diamond),
              Card(rank: Rank.ten, suit: Suit.spade),
              Card(rank: Rank.jack, suit: Suit.club),
            ]),
        isFalse,
      );
    },
  );
}
