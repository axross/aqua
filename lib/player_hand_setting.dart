// import 'package:aqua/card.dart' show Card;
// import 'package:aqua/card_pair.dart' show CardPair;
// import 'package:aqua/hand_range_part.dart';
// import "package:flutter/foundation.dart";

// class PlayerHandSettingList extends ChangeNotifier {
//   PlayerHandSettingList() {
//     for (final setting in playerHandSettings) {
//       _registerListener(setting);
//     }
//   }

//   List<PlayerHandSetting> playerHandSettings = [
//     PlayerHandHoleCardSetting(),
//     PlayerHandHoleCardSetting(),
//   ];

//   final _listeners = Map<PlayerHandSetting, void Function()>();

//   bool get isReadyToCalculate {
//     final usedCards = Set<Card>();

//     for (final setting in playerHandSettings) {
//       if (setting.cardPairCombinations.isEmpty) return false;

//       if (setting is PlayerHandHoleCardSetting) {
//         if (usedCards.contains(setting.leftCard)) return false;
//         if (usedCards.contains(setting.rightCard)) return false;

//         usedCards.add(setting.leftCard);
//         usedCards.add(setting.rightCard);
//       }
//     }

//     return true;
//   }

//   int get length => playerHandSettings.length;

//   bool get isFull => length == 10;

//   void addNew() {
//     assert(!isFull);

//     final newSetting = PlayerHandHoleCardSetting();

//     playerHandSettings.add(newSetting);

//     _registerListener(newSetting);

//     notifyListeners();
//   }

//   void remove(PlayerHandSetting setting) {
//     playerHandSettings.remove(setting);

//     _unregisterListener(setting);

//     notifyListeners();
//   }

//   PlayerHandSetting operator [](int index) => playerHandSettings[index];

//   operator []=(int index, PlayerHandSetting setting) {
//     _unregisterListener(playerHandSettings[index]);

//     playerHandSettings[index] = setting;

//     _registerListener(playerHandSettings[index]);

//     notifyListeners();
//   }

//   _registerListener(PlayerHandSetting setting) {
//     final listener = () {
//       // final newUsedCards = Set<Card>();

//       // for (final setting in playerHandSettings) {
//       //   if (setting is PlayerHandHoleCardSetting) {
//       //     newUsedCards.add(setting.leftCard);
//       //     newUsedCards.add(setting.rightCard);
//       //   }
//       // }

//       // usedCards = newUsedCards;

//       notifyListeners();
//     };

//     setting.addListener(listener);
//     _listeners[setting] = listener;
//   }

//   _unregisterListener(PlayerHandSetting setting) {
//     if (_listeners.containsKey(setting)) {
//       setting.removeListener(_listeners[setting]);
//     }
//   }
// }

// abstract class PlayerHandSetting extends ChangeNotifier {
//   Set<CardPair> get cardPairCombinations;
// }

// class PlayerHandRangeSetting extends PlayerHandSetting {
//   Set<HandRangePart> _handRange = {};

//   Set<CardPair> get cardPairCombinations => _handRange.fold(
//       Set<CardPair>(),
//       (cardPairSet, handRangePart) =>
//           cardPairSet..addAll(handRangePart.combinations));

//   Set<HandRangePart> get handRange => _handRange;

//   set handRange(Set<HandRangePart> handRange) {
//     _handRange = handRange;

//     notifyListeners();
//   }
// }

// class PlayerHandHoleCardSetting extends PlayerHandSetting {
//   Card _leftCard;
//   Card _rightCard;

//   Set<CardPair> get cardPairCombinations =>
//       _leftCard != null && _rightCard != null
//           ? {CardPair(_leftCard, _rightCard)}
//           : {};

//   Card get leftCard => _leftCard;

//   Card get rightCard => _rightCard;

//   set leftCard(Card card) {
//     _leftCard = card;

//     notifyListeners();
//   }

//   set rightCard(Card card) {
//     _rightCard = card;

//     notifyListeners();
//   }
// }
