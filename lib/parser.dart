// import 'card.dart' show Card, Rank, Suit;
// import 'card_pair.dart' show CardPair;

// Set<CardPair> parseRangeString(String rangeString) {
//   final tokens =
//       _tokenRegExp.allMatches(rangeString).map((match) => match.group(0));

//   if (tokens.isEmpty) throw Error();
//   if (tokens.join("").length != rangeString.length) throw Error();

//   final holeCards = Set<CardPair>();

//   for (final token in tokens) {
//     final tokenString = token.toString();

//     if (_fullHandTokenRegExp.hasMatch(tokenString)) {
//       final highRank = _rankEachChar[tokenString[0]];
//       final highSuit = _suitEachChar[tokenString[1]];
//       final kickerRank = _rankEachChar[tokenString[2]];
//       final kickerSuit = _suitEachChar[tokenString[3]];

//       if (weakerThan(highRank, kickerRank)) throw new Error();
//       if (highRank == kickerRank && highSuit == kickerSuit) throw new Error();

//       final cardPair = CardPair(
//         Card(rank: highRank, suit: highSuit),
//         Card(rank: kickerRank, suit: kickerSuit),
//       );

//       holeCards.add(cardPair);

//       continue;
//     }

//     final highRank = _rankEachChar[tokenString[0]];
//     final kickerRank = _rankEachChar[tokenString[1]];
//     final isSuited =
//         tokenString.toString().length >= 3 && tokenString[2] == "s";
//     final includesAvobe =
//         tokenString.toString().length >= 3 && tokenString.endsWith("+");

//     if (weakerThan(highRank, kickerRank)) throw new Error();

//     if (highRank == kickerRank) {
//       if (isSuited) throw new Error();

//       for (final rank
//           in _ranksBetween(highRank, includesAvobe ? null : highRank)) {
//         for (final cardPair in _getAllOfsuitCardPairsByRank(rank, rank)) {
//           holeCards.add(cardPair);
//         }
//       }

//       continue;
//     }

//     for (final rank in _ranksBetween(kickerRank, highRank)) {
//       if (isSuited) {
//         for (final cardPair in _getAllSuitedCardPairsByRank(highRank, rank)) {
//           holeCards.add(cardPair);
//         }
//       } else {
//         for (final cardPair in _getAllOfsuitCardPairsByRank(highRank, rank)) {
//           holeCards.add(cardPair);
//         }
//       }
//     }
//   }

//   return holeCards;
// }

// bool weakerThan(Rank a, Rank b) =>
//     (a == Rank.ace ? 14 : a.index) < (b == Rank.ace ? 14 : b.index);

// Iterable<Rank> _ranksBetween(Rank from, Rank to) => _ranksInPowerOrder
//     .skipWhile((rank) => rank != from)
//     .takeWhile((rank) => rank != to);

// List<Rank> _ranksInPowerOrder = [
//   Rank.two,
//   Rank.three,
//   Rank.four,
//   Rank.five,
//   Rank.six,
//   Rank.seven,
//   Rank.eight,
//   Rank.nine,
//   Rank.ten,
//   Rank.jack,
//   Rank.queen,
//   Rank.king,
//   Rank.ace
// ];

// Set<CardPair> _getAllSuitedCardPairsByRank(Rank rankA, Rank rankB) => {
//       CardPair(
//         Card(rank: rankA, suit: Suit.spade),
//         Card(rank: rankB, suit: Suit.spade),
//       ),
//       CardPair(
//         Card(rank: rankA, suit: Suit.heart),
//         Card(rank: rankB, suit: Suit.heart),
//       ),
//       CardPair(
//         Card(rank: rankA, suit: Suit.diamond),
//         Card(rank: rankB, suit: Suit.diamond),
//       ),
//       CardPair(
//         Card(rank: rankA, suit: Suit.club),
//         Card(rank: rankB, suit: Suit.club),
//       ),
//     };

// Set<CardPair> _getAllOfsuitCardPairsByRank(Rank rankA, Rank rankB) => {
//       CardPair(
//         Card(rank: rankA, suit: Suit.spade),
//         Card(rank: rankB, suit: Suit.heart),
//       ),
//       CardPair(
//         Card(rank: rankA, suit: Suit.spade),
//         Card(rank: rankB, suit: Suit.diamond),
//       ),
//       CardPair(
//         Card(rank: rankA, suit: Suit.spade),
//         Card(rank: rankB, suit: Suit.club),
//       ),
//       CardPair(
//         Card(rank: rankA, suit: Suit.heart),
//         Card(rank: rankB, suit: Suit.diamond),
//       ),
//       CardPair(
//         Card(rank: rankA, suit: Suit.heart),
//         Card(rank: rankB, suit: Suit.club),
//       ),
//       CardPair(
//         Card(rank: rankA, suit: Suit.diamond),
//         Card(rank: rankB, suit: Suit.club),
//       ),
//       if (rankA != rankB) ...{
//         CardPair(
//           Card(rank: rankA, suit: Suit.heart),
//           Card(rank: rankB, suit: Suit.spade),
//         ),
//         CardPair(
//           Card(rank: rankA, suit: Suit.diamond),
//           Card(rank: rankB, suit: Suit.spade),
//         ),
//         CardPair(
//           Card(rank: rankA, suit: Suit.diamond),
//           Card(rank: rankB, suit: Suit.heart),
//         ),
//         CardPair(
//           Card(rank: rankA, suit: Suit.club),
//           Card(rank: rankB, suit: Suit.spade),
//         ),
//         CardPair(
//           Card(rank: rankA, suit: Suit.club),
//           Card(rank: rankB, suit: Suit.heart),
//         ),
//         CardPair(
//           Card(rank: rankA, suit: Suit.club),
//           Card(rank: rankB, suit: Suit.diamond),
//         ),
//       }
//     };

// final _tokenRegExp =
//     RegExp(r"([AKQJT2-9][AKQJT2-9][so]?\+?|[AKQJT2-9][shdc][AKQJT2-9][shdc])");

// final _fullHandTokenRegExp = RegExp(r"^[AKQJT2-9][sdhc][AKQJT2-9][sdhc]$");

// const _suitEachChar = {
//   "s": Suit.spade,
//   "h": Suit.heart,
//   "d": Suit.diamond,
//   "c": Suit.club,
// };

// const _rankEachChar = {
//   "A": Rank.ace,
//   "2": Rank.two,
//   "3": Rank.three,
//   "4": Rank.four,
//   "5": Rank.five,
//   "6": Rank.six,
//   "7": Rank.seven,
//   "8": Rank.eight,
//   "9": Rank.nine,
//   "T": Rank.ten,
//   "J": Rank.jack,
//   "Q": Rank.queen,
//   "K": Rank.king,
// };
