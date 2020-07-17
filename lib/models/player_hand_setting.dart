import "package:poker/poker.dart";
import 'package:meta/meta.dart';

// class PlayerHandSetting {

//   final List<CardPair> holeCards = [];

//   final Set<HandRangePart> handRange = {};

//   Set<CardPairCombinationsGeneratable> get components {
//     final components = <CardPairCombinationsGeneratable>{};

//     for (final holeCards in holeCards) {
//       if (holeCards[0] && holeCards[1]) {

//       }
//     }
//   }

//   Set<CardPair> get cardPairCombinations => components.fold(<CardPair>{},
//       (combs, component) => combs..addAll(component.cardPairCombinations));

//   double get cardPairCombinationRatio => cardPairCombinations.length / 1326;
// }

// class HoleCardPlayerHandSetting extends PlayerHandSetting {
//   HoleCardPlayerHandSetting(Card a, Card b);

//   HoleCardPlayerHandSetting.empty()
//       : a = null,
//         b = null;

//   Card a;

//   Card b;

//   get components {
//     if (a != null && b != null) {
//       return {HoleCards(cardPair: CardPair(a, b))};
//     }

//     return {};
//   }
// }

// class HandRangePlayerHandSetting extends PlayerHandSetting {
//   HandRangePlayerHandSetting(this.components) : assert(components != null);

//   HandRangePlayerHandSetting.empty() : components = {};

//   var components;
// }

// // class MixedHandRangePlayerHandSetting implements PlayerHandSetting {}

// // class PlayerHandSetting {
// //   PlayerHandSetting({
// //     @required this.components,
// //     this.type = PlayerHandSettingType.mixed,
// //   }) : assert(components != null);

// //   PlayerHandSetting.fromCardPair(CardPair cardPair)
// //       : components = {HoleCards(cardPair: cardPair)},
// //         type = PlayerHandSettingType.holeCards;

// //   PlayerHandSetting.fromHandRange(this.components)
// //       : type = PlayerHandSettingType.holeCards;

// //   PlayerHandSetting.emptyHoleCards()
// //       : components = {},
// //         type = PlayerHandSettingType.holeCards;

// //   PlayerHandSetting.emptyHandRange()
// //       : components = {},
// //         type = PlayerHandSettingType.handRange;

// //   final Set<CardPairCombinationsGeneratable> components;

// //   PlayerHandSettingType type;

// //   HoleCards get asHoleCards {
// //     assert(type == PlayerHandSettingType.holeCards);

// //     return components.first;
// //   }

// //   Set<HandRangePart> get asHandRange {
// //     assert(type == PlayerHandSettingType.handRange);

// //     return Set<HandRangePart>.from(components);
// //   }

// //   int get cardPairCombinationLength => components.fold(
// //       0, (length, component) => length + component.cardPairCombinations.length);

// //   double get cardPairCombinationPercentage => cardPairCombinationLength / 1326;
// // }

// // enum PlayerHandSettingType {
// //   holeCards,
// //   handRange,
// //   mixed,
// // }

// // abstract class PlayerHandSettingRangePart {
// //   Set<CardPair> get cardPairCombinations;
// // }

// // @immutable
// // class HoleCards implements PlayerHandSettingRangePart {
// //   HoleCards({this.left, this.right});

// //   final Card left;
// //   final Card right;

// //   @override
// //   Set<CardPair> get cardPairCombinations =>
// //       left != null && right != null ? {CardPair(left, right)} : {};

// //   @override
// //   int get hashCode => left.hashCode * 17 + right.hashCode;

// //   @override
// //   bool operator ==(Object other) =>
// //       other is HoleCards && other.left == left && other.right == right;
// // }

// // @immutable
// // class HandRangePart implements PlayerHandSettingRangePart {
// //   const HandRangePart({
// //     @required this.high,
// //     @required this.kicker,
// //     bool isSuited,
// //   })  : assert(high != null),
// //         assert(kicker != null),
// //         isSuited = isSuited ?? false;

// //   final Rank high;
// //   final Rank kicker;
// //   final bool isSuited;

// //   bool get isPocket => high == kicker;

// //   @override
// //   Set<CardPair> get cardPairCombinations => isSuited
// //       ? _getAllSuitedCardPairsByRank(high, kicker)
// //       : _getAllOfsuitCardPairsByRank(high, kicker);

// //   @override
// //   String toString() => "HandRangePart<$high, $kicker, isSuited: $isSuited>";

// //   @override
// //   int get hashCode =>
// //       high.hashCode * 17 * 17 + kicker.hashCode * 17 + isSuited.hashCode;

// //   @override
// //   bool operator ==(Object other) =>
// //       other is HandRangePart &&
// //       other.high == high &&
// //       other.kicker == kicker &&
// //       other.isSuited == isSuited;
// // }

// // Set<CardPair> _getAllSuitedCardPairsByRank(Rank rankA, Rank rankB) => {
// //       CardPair(
// //         Card(rank: rankA, suit: Suit.spade),
// //         Card(rank: rankB, suit: Suit.spade),
// //       ),
// //       CardPair(
// //         Card(rank: rankA, suit: Suit.heart),
// //         Card(rank: rankB, suit: Suit.heart),
// //       ),
// //       CardPair(
// //         Card(rank: rankA, suit: Suit.diamond),
// //         Card(rank: rankB, suit: Suit.diamond),
// //       ),
// //       CardPair(
// //         Card(rank: rankA, suit: Suit.club),
// //         Card(rank: rankB, suit: Suit.club),
// //       ),
// //     };

// // Set<CardPair> _getAllOfsuitCardPairsByRank(Rank rankA, Rank rankB) => {
// //       CardPair(
// //         Card(rank: rankA, suit: Suit.spade),
// //         Card(rank: rankB, suit: Suit.heart),
// //       ),
// //       CardPair(
// //         Card(rank: rankA, suit: Suit.spade),
// //         Card(rank: rankB, suit: Suit.diamond),
// //       ),
// //       CardPair(
// //         Card(rank: rankA, suit: Suit.spade),
// //         Card(rank: rankB, suit: Suit.club),
// //       ),
// //       CardPair(
// //         Card(rank: rankA, suit: Suit.heart),
// //         Card(rank: rankB, suit: Suit.diamond),
// //       ),
// //       CardPair(
// //         Card(rank: rankA, suit: Suit.heart),
// //         Card(rank: rankB, suit: Suit.club),
// //       ),
// //       CardPair(
// //         Card(rank: rankA, suit: Suit.diamond),
// //         Card(rank: rankB, suit: Suit.club),
// //       ),
// //       if (rankA != rankB) ...{
// //         CardPair(
// //           Card(rank: rankA, suit: Suit.heart),
// //           Card(rank: rankB, suit: Suit.spade),
// //         ),
// //         CardPair(
// //           Card(rank: rankA, suit: Suit.diamond),
// //           Card(rank: rankB, suit: Suit.spade),
// //         ),
// //         CardPair(
// //           Card(rank: rankA, suit: Suit.diamond),
// //           Card(rank: rankB, suit: Suit.heart),
// //         ),
// //         CardPair(
// //           Card(rank: rankA, suit: Suit.club),
// //           Card(rank: rankB, suit: Suit.spade),
// //         ),
// //         CardPair(
// //           Card(rank: rankA, suit: Suit.club),
// //           Card(rank: rankB, suit: Suit.heart),
// //         ),
// //         CardPair(
// //           Card(rank: rankA, suit: Suit.club),
// //           Card(rank: rankB, suit: Suit.diamond),
// //         ),
// //       },
// //     };
