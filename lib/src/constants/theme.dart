import "package:aqua/src/common_widgets/aqua_button.dart";
import "package:aqua/src/common_widgets/aqua_scaffold.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/digits_text.dart";
import "package:flutter/painting.dart";
import "package:poker/poker.dart";

const _white = Color(0xffffffff);
const _lessWhite = Color(0xfff2f2f7);
const _silverSand = Color(0xffC5C9D0);
const _black = Color(0xff000000);
const _lessBlack = Color(0xff1c1c1e);
const _davysGrey = Color(0xff5A5E63);
const _gunmetal = Color(0xff29333D);
const _aliceBlue = Color(0xffE8ECF1);
const _cadetGrey = Color(0xff98A0A8);
const _lemonPeel = Color(0xffF5B83D);
const _chineseYellow = Color(0xffFFB41C);
const _pullmanBrown = Color(0xff503D14);
const _bananaMania = Color(0xffFBE8BF);
const _charcoal = Color(0xff304050);
const _frenchBlue = Color(0xff368CE2);
const _beauBlue = Color(0xffBDD9F5);
const _prussianBlue = Color(0xff122E4A);
const _candyPink = Color(0xffE96363);
// ignore: unused_element
const _spanishPink = Color(0xfff5bcbc);
// ignore: unused_element
const _darkSienna = Color(0xff4C2020);
const _jungleGreen = Color(0xff19B38C);
// ignore: unused_element
const _lightCyan = Color(0xffC6ECE2);
// ignore: unused_element
const _phthaloGreen = Color(0xff062D23);

const baseTextStyle = TextStyle(
  fontFamily: "Poppins",
  fontSize: 16,
  fontWeight: FontWeight.w400,
  // decoration: TextDecoration.none,
);

final baseButtonTextStyle = baseTextStyle.copyWith(
  fontSize: 14,
  fontFamily: "Poppins",
  fontWeight: FontWeight.w500,
);

final lightTheme = AquaThemeData(
  scaffoldStyle: AquaScaffoldStyle(
    titleTextStyle: baseTextStyle.copyWith(
      color: _gunmetal,
      fontSize: 32,
      fontWeight: FontWeight.w600,
    ),
    backgroundColor: _white,
  ),
  buttonStyleSet: AquaButtonStyleSet(
    normal: AquaButtonStyle(
      labelTextStyle: baseButtonTextStyle.copyWith(color: _white),
      backgroundColor: _gunmetal,
    ),
    primary: AquaButtonStyle(
      labelTextStyle: baseButtonTextStyle.copyWith(color: _white),
      backgroundColor: _frenchBlue,
    ),
    secondary: AquaButtonStyle(
      labelTextStyle: baseButtonTextStyle.copyWith(color: _frenchBlue),
      backgroundColor: _beauBlue,
    ),
    danger: AquaButtonStyle(
      labelTextStyle: baseButtonTextStyle.copyWith(color: _white),
      backgroundColor: _candyPink,
    ),
  ),
  textStyleSet: AquaTextStyleSet(
    headline: baseTextStyle.copyWith(
      color: _gunmetal,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
    body: baseTextStyle.copyWith(color: _gunmetal),
    caption: baseTextStyle.copyWith(
      color: _cadetGrey,
      fontSize: 13.0,
    ),
    errorCaption: baseTextStyle.copyWith(
      color: _candyPink,
      fontSize: 13.0,
    ),
  ),
  digitTextStyle: AquaDigitTextStyle(
    color: _gunmetal,
    placeholderColor: _silverSand,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w700,
    fontSizeFactor: 1.15,
    largeFontSizeFactor: 2.3,
  ),
  playingCardStyle: AquaPlayingCardStyle(
    textStyle: TextStyle(
      fontFamily: "Work Sans",
      fontWeight: FontWeight.w600,
    ),
    backgroundColor: _lessWhite,
    suitColors: {
      Suit.spade: _charcoal,
      Suit.heart: _candyPink,
      Suit.diamond: _frenchBlue,
      Suit.club: _jungleGreen,
    },
  ),
  handRangeGridStyle: AquaHandRangeGridStyle(
    backgroundColor: _lessWhite,
    textStyle: baseTextStyle.copyWith(
      color: _silverSand,
      fontFamily: "Work Sans",
    ),
    selectedBackgroundColor: _bananaMania,
    selectedForegroundColor: _lemonPeel,
  ),
  sliderStyle: AquaSliderStyle(
    thumbColor: _gunmetal,
    activeTrackColor: _gunmetal,
    inactiveTrackColor: _silverSand,
    valueIndicatorColor: _gunmetal,
    valueIndicatorTextStyle: baseButtonTextStyle.copyWith(color: _white),
  ),
  cursorColor: _lemonPeel,
);

final darkTheme = AquaThemeData(
  scaffoldStyle: AquaScaffoldStyle(
    titleTextStyle: baseTextStyle.copyWith(
      color: _white,
      fontSize: 32,
      fontWeight: FontWeight.w600,
    ),
    backgroundColor: _black,
  ),
  buttonStyleSet: AquaButtonStyleSet(
    normal: AquaButtonStyle(
      labelTextStyle: baseButtonTextStyle.copyWith(color: _black),
      backgroundColor: _aliceBlue,
    ),
    primary: AquaButtonStyle(
      labelTextStyle: baseButtonTextStyle.copyWith(color: _white),
      backgroundColor: _frenchBlue,
    ),
    secondary: AquaButtonStyle(
      labelTextStyle: baseButtonTextStyle.copyWith(color: _frenchBlue),
      backgroundColor: _prussianBlue,
    ),
    danger: AquaButtonStyle(
      labelTextStyle: baseButtonTextStyle.copyWith(color: _white),
      backgroundColor: _candyPink,
    ),
  ),
  textStyleSet: AquaTextStyleSet(
    headline: baseTextStyle.copyWith(
      color: _white,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
    body: baseTextStyle.copyWith(color: _white),
    caption: baseTextStyle.copyWith(
      color: _cadetGrey,
      fontSize: 13.0,
    ),
    errorCaption: baseTextStyle.copyWith(
      color: _candyPink,
      fontSize: 13.0,
    ),
  ),
  playingCardStyle: AquaPlayingCardStyle(
    textStyle: TextStyle(
      fontFamily: "Work Sans",
      fontWeight: FontWeight.w600,
    ),
    backgroundColor: _lessBlack,
    suitColors: {
      Suit.spade: _aliceBlue,
      Suit.heart: _candyPink,
      Suit.diamond: _frenchBlue,
      Suit.club: _jungleGreen,
    },
  ),
  handRangeGridStyle: AquaHandRangeGridStyle(
    backgroundColor: _lessBlack,
    textStyle: baseTextStyle.copyWith(
      color: _davysGrey,
      fontFamily: "Work Sans",
    ),
    selectedBackgroundColor: _pullmanBrown,
    selectedForegroundColor: _chineseYellow,
  ),
  digitTextStyle: AquaDigitTextStyle(
    color: _white,
    placeholderColor: _davysGrey,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w700,
    fontSizeFactor: 1.15,
    largeFontSizeFactor: 2.3,
  ),
  sliderStyle: AquaSliderStyle(
    thumbColor: _aliceBlue,
    activeTrackColor: _aliceBlue,
    inactiveTrackColor: _davysGrey,
    valueIndicatorColor: _aliceBlue,
    valueIndicatorTextStyle: baseButtonTextStyle.copyWith(color: _black),
  ),
  cursorColor: _chineseYellow,
);
