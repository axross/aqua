import 'dart:ui' show Brightness;
import 'package:aqua/models/suit.dart';
import 'package:flutter/widgets.dart';

class AquaTheme extends InheritedWidget {
  AquaTheme({
    @required this.lightThemeData,
    @required this.darkThemeData,
    @required this.child,
  })  : assert(lightThemeData != null),
        assert(darkThemeData != null),
        assert(child != null);

  final AquaThemeData lightThemeData;

  final AquaThemeData darkThemeData;

  final Widget child;

  @override
  bool updateShouldNotify(AquaTheme old) =>
      lightThemeData != old.lightThemeData ||
      darkThemeData != old.darkThemeData;

  static AquaThemeData of(BuildContext context) {
    final theme = context.inheritFromWidgetOfExactType(AquaTheme) as AquaTheme;

    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? theme.darkThemeData
        : theme.lightThemeData;
  }
}

class AquaThemeData {
  const AquaThemeData({
    @required this.textStyle,
    @required this.foregroundColor,
    @required this.secondaryForegroundColor,
    @required this.accentForegroundColor,
    @required this.errorForegroundColor,
    @required this.backgroundColor,
    @required this.secondaryBackgroundColor,
    @required this.highlightBackgroundColor,
    @required this.appBarBackgroundColor,
    @required this.appBarForegroundColor,
    @required this.appBarTextStyle,
    @required this.digitTextStyle,
    @required this.playingCardBackgroundColor,
    @required this.spadeForegroundColor,
    @required this.heartForegroundColor,
    @required this.diamondForegroundColor,
    @required this.clubForegroundColor,
    @required this.playingCardTextStyle,
    @required this.rangeBackgroundColor,
    @required this.pocketRangeBackgroundColor,
    @required this.selectedRangeBackgroundColor,
    @required this.rangeForegroundColor,
    @required this.pocketRangeForegroundColor,
    @required this.selectedRangeForegroundColor,
    @required this.rangeTextStyle,
    @required this.assets,
  });

  final TextStyle textStyle;

  final Color foregroundColor;
  final Color secondaryForegroundColor;
  final Color accentForegroundColor;
  final Color errorForegroundColor;

  final Color backgroundColor;
  final Color secondaryBackgroundColor;
  final Color highlightBackgroundColor;

  final Color appBarBackgroundColor;
  final Color appBarForegroundColor;
  final TextStyle appBarTextStyle;

  final TextStyle digitTextStyle;

  final Color playingCardBackgroundColor;
  final Color spadeForegroundColor;
  final Color heartForegroundColor;
  final Color diamondForegroundColor;
  final Color clubForegroundColor;
  final TextStyle playingCardTextStyle;

  final Color rangeBackgroundColor;
  final Color pocketRangeBackgroundColor;
  final Color selectedRangeBackgroundColor;
  final Color rangeForegroundColor;
  final Color pocketRangeForegroundColor;
  final Color selectedRangeForegroundColor;
  final TextStyle rangeTextStyle;

  final AquaThemedAssets assets;

  @override
  int get hashCode {
    int result = 17;

    result = 37 * result + textStyle.hashCode;
    result = 37 * result + foregroundColor.hashCode;
    result = 37 * result + secondaryForegroundColor.hashCode;
    result = 37 * result + accentForegroundColor.hashCode;
    result = 37 * result + backgroundColor.hashCode;
    result = 37 * result + secondaryBackgroundColor.hashCode;
    result = 37 * result + highlightBackgroundColor.hashCode;
    result = 37 * result + appBarBackgroundColor.hashCode;
    result = 37 * result + playingCardBackgroundColor.hashCode;
    result = 37 * result + spadeForegroundColor.hashCode;
    result = 37 * result + heartForegroundColor.hashCode;
    result = 37 * result + diamondForegroundColor.hashCode;
    result = 37 * result + clubForegroundColor.hashCode;
    result = 37 * result + playingCardTextStyle.hashCode;
    result = 37 * result + rangeBackgroundColor.hashCode;
    result = 37 * result + pocketRangeBackgroundColor.hashCode;
    result = 37 * result + selectedRangeBackgroundColor.hashCode;
    result = 37 * result + rangeForegroundColor.hashCode;
    result = 37 * result + pocketRangeForegroundColor.hashCode;
    result = 37 * result + selectedRangeForegroundColor.hashCode;
    result = 37 * result + rangeTextStyle.hashCode;

    return result;
  }

  @override
  bool operator ==(Object other) =>
      other is AquaThemeData &&
      other.textStyle == textStyle &&
      other.foregroundColor == foregroundColor &&
      other.secondaryForegroundColor == secondaryForegroundColor &&
      other.accentForegroundColor == accentForegroundColor &&
      other.backgroundColor == backgroundColor &&
      other.secondaryBackgroundColor == secondaryBackgroundColor &&
      other.highlightBackgroundColor == highlightBackgroundColor &&
      other.appBarBackgroundColor == appBarBackgroundColor &&
      other.playingCardBackgroundColor == playingCardBackgroundColor &&
      other.spadeForegroundColor == spadeForegroundColor &&
      other.heartForegroundColor == heartForegroundColor &&
      other.diamondForegroundColor == diamondForegroundColor &&
      other.clubForegroundColor == clubForegroundColor &&
      other.playingCardTextStyle == playingCardTextStyle &&
      other.rangeBackgroundColor == rangeBackgroundColor &&
      other.pocketRangeBackgroundColor == pocketRangeBackgroundColor &&
      other.selectedRangeBackgroundColor == selectedRangeBackgroundColor &&
      other.rangeForegroundColor == rangeForegroundColor &&
      other.pocketRangeForegroundColor == pocketRangeForegroundColor &&
      other.selectedRangeForegroundColor == selectedRangeForegroundColor &&
      other.rangeTextStyle == rangeTextStyle;
}

@immutable
class AquaThemedAssets {
  const AquaThemedAssets({
    @required this.suits,
  }) : assert(suits != null);

  final Map<Suit, AssetImage> suits;
}
