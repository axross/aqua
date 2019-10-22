// import 'package:meta/meta.dart' show immutable, required;
// import "package:flutter/foundation.dart" show ChangeNotifier;
// import './card.dart' show Card;
// import './hand.dart' show HandType;
// import './player_hand_setting.dart' show PlayerHandSetting, PlayerHoleCards;

// @immutable
// class SimulationSession {
//   SimulationSession({List<SimulationSessionPlayer> players})
//       : _players = players == null
//             ? [
//                 SimulationSessionPlayer(
//                   handSetting: PlayerHoleCards(),
//                 ),
//                 SimulationSessionPlayer(
//                   handSetting: PlayerHoleCards(),
//                 ),
//               ]
//             : players;

//   final List<SimulationSessionPlayer> _players;

//   int get length => _players.length;

//   bool get isFullPlayer => _players.length == 10;

//   bool get isReadyToSimulate {
//     final usedCards = Set<Card>();

//     for (final player in _players) {
//       final handSetting = player.handSetting;

//       if (handSetting.cardPairCombinations.isEmpty) return false;

//       if (handSetting is PlayerHoleCards) {
//         if (usedCards.contains(handSetting[0])) return false;
//         if (usedCards.contains(handSetting[1])) return false;

//         usedCards.add(handSetting[0]);
//         usedCards.add(handSetting[1]);
//       }
//     }

//     return true;
//   }

//   Iterable<PlayerHandSetting> get handSettings =>
//       _players.map((player) => player.handSetting);

//   SimulationSession copyWithNewPlayer() {
//     assert(!isFullPlayer);

//     return SimulationSession(
//       players: [..._players]..add(SimulationSessionPlayer(
//           handSetting: PlayerHoleCards(),
//         )),
//     );
//   }

//   SimulationSession copyWithRemoving(SimulationSessionPlayer player) =>
//       SimulationSession(
//         players: [..._players]..remove(player),
//       );

//   SimulationSession copyWithResult() => SimulationSession();

//   SimulationSessionPlayer operator [](int index) {
//     assert(index >= 0 && index < _players.length);

//     return _players[index];
//   }
// }

// @immutable
// class SimulationSessionPlayer extends ChangeNotifier {
//   SimulationSessionPlayer({@required PlayerHandSetting handSetting})
//       : _handSetting = handSetting == null ? PlayerHoleCards() : handSetting,
//         result = {
//           HandType.high: HandTypeResult(),
//           HandType.aPair: HandTypeResult(),
//           HandType.twoPairs: HandTypeResult(),
//           HandType.threeOfAKind: HandTypeResult(),
//           HandType.straight: HandTypeResult(),
//           HandType.flush: HandTypeResult(),
//           HandType.fullhouse: HandTypeResult(),
//           HandType.fourOfAKind: HandTypeResult(),
//           HandType.straightFlush: HandTypeResult(),
//         },
//         assert(handSetting != null);

//   PlayerHandSetting _handSetting;

//   final Map<HandType, HandTypeResult> result;

//   PlayerHandSetting get handSetting => _handSetting;

//   SimulationSessionPlayer copyWithHandSetting(PlayerHandSetting handSetting) =>
//       SimulationSessionPlayer(handSetting: handSetting);
// }

// class HandTypeResult {
//   HandTypeResult();

//   HandTypeResult.fromJson(Map<String, dynamic> json)
//       : won = json['won'],
//         lost = json['lost'],
//         even = json['even'];

//   int won = 0;
//   int lost = 0;
//   int even = 0;

//   Map<String, dynamic> toJson() => {
//         'won': won,
//         'lost': lost,
//         'even': even,
//       };
// }
