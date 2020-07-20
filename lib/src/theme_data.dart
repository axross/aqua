import 'package:aqua/src/common_widgets/aqua_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:poker/poker.dart';

const lightThemeData = AquaThemeData(
  textStyle: TextStyle(
    color: Color(0xff343e4a),
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
    fontSize: 16,
  ),
  digitTextStyle: TextStyle(
    color: Color(0xff343e4a),
    fontFamily: "Source Code Pro",
    fontWeight: FontWeight.w700,
    fontSize: 16,
  ),
  rankTextStyle: TextStyle(
    color: Color(0xff343e4a),
    fontFamily: "Work Sans",
    fontWeight: FontWeight.w600,
    fontSize: 16,
  ),
  appBarTextStyle: TextStyle(
    color: Color(0xff343e4a),
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
    fontSize: 20,
  ),
  foregroundColor: Color(0xff343e4a),
  whiteForegroundColor: Color(0xffffffff),
  secondaryForegroundColor: Color(0xff9dacbd),
  dimForegroundColor: Color(0xffc8d6e5),
  highlightForegroundColor: Color(0xffff9f43),
  primaryForegroundColor: Color(0xff54a0ff),
  errorForegroundColor: Color(0xffff6b6b),
  backgroundColor: Color(0xffffffff),
  secondaryBackgroundColor: Color(0xffd8e2ed),
  dimBackgroundColor: Color(0xfff1f5f8),
  highlightBackgroundColor: Color(0xfffeca57),
  primaryBackgroundColor: Color(0xff2e86de),
  errorBackgroundColor: Color(0xffee5253),
  spadeForegroundColor: Color(0xff576574),
  heartForegroundColor: Color(0xffff6b6b),
  diamondForegroundColor: Color(0xff54a0ff),
  clubForegroundColor: Color(0xff1dd1a1),
  assets: AquaThemedAssets(
    suits: {
      Suit.spade: AssetImage("assets/images/spade.png"),
      Suit.heart: AssetImage("assets/images/heart.png"),
      Suit.diamond: AssetImage("assets/images/diamond-4c.png"),
      Suit.club: AssetImage("assets/images/club-4c.png"),
    },
  ),
);

const darkThemeData = AquaThemeData(
  textStyle: TextStyle(
    color: Color(0xff343e4a),
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
    fontSize: 16,
  ),
  digitTextStyle: TextStyle(
    color: Color(0xff343e4a),
    fontFamily: "Source Code Pro",
    fontWeight: FontWeight.w700,
    fontSize: 16,
  ),
  rankTextStyle: TextStyle(
    color: Color(0xff343e4a),
    fontFamily: "Work Sans",
    fontWeight: FontWeight.w600,
    fontSize: 16,
  ),
  appBarTextStyle: TextStyle(
    color: Color(0xfff1f4f8),
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
    fontSize: 20,
  ),
  foregroundColor: Color(0xfff1f4f8),
  whiteForegroundColor: Color(0xffffffff),
  secondaryForegroundColor: Color(0xff8395a7),
  dimForegroundColor: Color(0xff576574),
  highlightForegroundColor: Color(0xffff9f43),
  primaryForegroundColor: Color(0xff54a0ff),
  errorForegroundColor: Color(0xffff6b6b),
  backgroundColor: Color(0xff19232E),
  secondaryBackgroundColor: Color(0xff3C4A58),
  dimBackgroundColor: Color(0xff222f3e),
  highlightBackgroundColor: Color(0xfffeca57),
  primaryBackgroundColor: Color(0xff2e86de),
  errorBackgroundColor: Color(0xffee5253),
  spadeForegroundColor: Color(0xfff1f4f8),
  heartForegroundColor: Color(0xffff6b6b),
  diamondForegroundColor: Color(0xff54a0ff),
  clubForegroundColor: Color(0xff1dd1a1),
  assets: AquaThemedAssets(
    suits: {
      Suit.spade: AssetImage("assets/images/spade-inversed.png"),
      Suit.heart: AssetImage("assets/images/heart.png"),
      Suit.diamond: AssetImage("assets/images/diamond-4c.png"),
      Suit.club: AssetImage("assets/images/club-4c.png"),
    },
  ),
);
