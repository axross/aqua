import 'package:aqua/models/suit.dart';
import 'package:aqua/widgets/aqua_theme.dart';
import 'package:flutter/widgets.dart';

final lightThemeData = AquaThemeData(
  textStyle: TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
    fontSize: 16,
  ),
  foregroundColor: Color(0xff222f3e),
  secondaryForegroundColor: Color(0xff8395a7),
  accentForegroundColor: Color(0xff2e86de),
  errorForegroundColor: Color(0xffff6b6b),
  backgroundColor: Color(0xfff7fbff),
  secondaryBackgroundColor: Color(0xffc8d6e5),
  highlightBackgroundColor: Color(0xfffeca57),
  appBarBackgroundColor: Color(0xfff1f5f8),
  appBarForegroundColor: Color(0xff10171E),
  appBarTextStyle: TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
    fontSize: 20,
  ),
  digitTextStyle: TextStyle(
    fontFamily: "Source Code Pro",
    fontWeight: FontWeight.w700,
    fontSize: 32,
  ),
  playingCardBackgroundColor: Color(0xfff1f5f8),
  spadeForegroundColor: Color(0xff576574),
  heartForegroundColor: Color(0xffff6b6b),
  diamondForegroundColor: Color(0xff54a0ff),
  clubForegroundColor: Color(0xff1dd1a1),
  playingCardTextStyle: TextStyle(
    fontFamily: "Work Sans",
    fontWeight: FontWeight.w600,
    fontSize: 16,
    decoration: TextDecoration.none,
  ),
  rangeBackgroundColor: Color(0xfff1f5f8),
  pocketRangeBackgroundColor: Color(0x3ffeca57),
  selectedRangeBackgroundColor: Color(0xff1dd1a1),
  rangeForegroundColor: Color(0xffc8d6e5),
  pocketRangeForegroundColor: Color(0xfffeca57),
  selectedRangeForegroundColor: Color(0xffffffff),
  rangeTextStyle: TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
    fontSize: 14,
    decoration: TextDecoration.none,
  ),
  assets: AquaThemedAssets(
    suits: {
      Suit.spade: AssetImage("assets/images/spade.png"),
      Suit.heart: AssetImage("assets/images/heart.png"),
      Suit.diamond: AssetImage("assets/images/diamond-4c.png"),
      Suit.club: AssetImage("assets/images/club-4c.png"),
    },
  ),
);

final darkThemeData = AquaThemeData(
  textStyle: TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
    fontSize: 16,
  ),
  foregroundColor: Color(0xffF1F4F8),
  secondaryForegroundColor: Color(0xff8395a7),
  accentForegroundColor: Color(0xff2e86de),
  errorForegroundColor: Color(0xffff6b6b),
  backgroundColor: Color(0xff19232E),
  secondaryBackgroundColor: Color(0xff576574),
  highlightBackgroundColor: Color(0xfffeca57),
  appBarBackgroundColor: Color(0xff222f3e),
  appBarForegroundColor: Color(0xffF1F4F8),
  appBarTextStyle: TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
    fontSize: 20,
  ),
  digitTextStyle: TextStyle(
    fontFamily: "Source Code Pro",
    fontWeight: FontWeight.w700,
    fontSize: 32,
  ),
  playingCardBackgroundColor: Color(0xff222f3e),
  spadeForegroundColor: Color(0xffc8d6e5),
  heartForegroundColor: Color(0xffff6b6b),
  diamondForegroundColor: Color(0xff54a0ff),
  clubForegroundColor: Color(0xff1dd1a1),
  playingCardTextStyle: TextStyle(
    fontFamily: "Work Sans",
    fontWeight: FontWeight.w600,
    fontSize: 16,
    decoration: TextDecoration.none,
  ),
  rangeBackgroundColor: Color(0xff222f3e),
  pocketRangeBackgroundColor: Color(0x3ffeca57),
  selectedRangeBackgroundColor: Color(0xff1dd1a1),
  rangeForegroundColor: Color(0xff576574),
  pocketRangeForegroundColor: Color(0xfffeca57),
  selectedRangeForegroundColor: Color(0xffffffff),
  rangeTextStyle: TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
    fontSize: 14,
    decoration: TextDecoration.none,
  ),
  assets: AquaThemedAssets(
    suits: {
      Suit.spade: AssetImage("assets/images/spade-inversed.png"),
      Suit.heart: AssetImage("assets/images/heart.png"),
      Suit.diamond: AssetImage("assets/images/diamond-4c.png"),
      Suit.club: AssetImage("assets/images/club-4c.png"),
    },
  ),
);
