import 'dart:ui' show Brightness;
import 'package:flutter/widgets.dart';
import 'package:poker/poker.dart';

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
    final theme = context.dependOnInheritedWidgetOfExactType<AquaTheme>();

    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? theme.darkThemeData
        : theme.lightThemeData;
  }
}

class AquaThemeData {
  const AquaThemeData({
    @required this.textStyle,
    @required this.digitTextStyle,
    @required this.rankTextStyle,
    @required this.appBarTextStyle,
    @required this.foregroundColor,
    @required this.whiteForegroundColor,
    @required this.secondaryForegroundColor,
    @required this.dimForegroundColor,
    @required this.highlightForegroundColor,
    @required this.primaryForegroundColor,
    @required this.errorForegroundColor,
    @required this.backgroundColor,
    @required this.secondaryBackgroundColor,
    @required this.dimBackgroundColor,
    @required this.highlightBackgroundColor,
    @required this.primaryBackgroundColor,
    @required this.errorBackgroundColor,
    @required this.spadeForegroundColor,
    @required this.heartForegroundColor,
    @required this.diamondForegroundColor,
    @required this.clubForegroundColor,
    @required this.assets,
  });

  final TextStyle textStyle;
  final TextStyle digitTextStyle;
  final TextStyle rankTextStyle;
  final TextStyle appBarTextStyle;

  final Color foregroundColor;
  final Color whiteForegroundColor;
  final Color secondaryForegroundColor;
  final Color dimForegroundColor;
  final Color highlightForegroundColor;
  final Color primaryForegroundColor;
  final Color errorForegroundColor;

  final Color backgroundColor;
  final Color secondaryBackgroundColor;
  final Color dimBackgroundColor;
  final Color highlightBackgroundColor;
  final Color primaryBackgroundColor;
  final Color errorBackgroundColor;

  final Color spadeForegroundColor;
  final Color heartForegroundColor;
  final Color diamondForegroundColor;
  final Color clubForegroundColor;

  final AquaThemedAssets assets;

  @override
  int get hashCode {
    int result = 17;

    result = 37 * result + textStyle.hashCode;
    result = 37 * result + digitTextStyle.hashCode;
    result = 37 * result + rankTextStyle.hashCode;
    result = 37 * result + appBarTextStyle.hashCode;
    result = 37 * result + foregroundColor.hashCode;
    result = 37 * result + whiteForegroundColor.hashCode;
    result = 37 * result + secondaryForegroundColor.hashCode;
    result = 37 * result + dimForegroundColor.hashCode;
    result = 37 * result + highlightForegroundColor.hashCode;
    result = 37 * result + primaryForegroundColor.hashCode;
    result = 37 * result + errorForegroundColor.hashCode;
    result = 37 * result + backgroundColor.hashCode;
    result = 37 * result + secondaryBackgroundColor.hashCode;
    result = 37 * result + dimBackgroundColor.hashCode;
    result = 37 * result + highlightBackgroundColor.hashCode;
    result = 37 * result + primaryBackgroundColor.hashCode;
    result = 37 * result + errorForegroundColor.hashCode;
    result = 37 * result + spadeForegroundColor.hashCode;
    result = 37 * result + heartForegroundColor.hashCode;
    result = 37 * result + diamondForegroundColor.hashCode;
    result = 37 * result + clubForegroundColor.hashCode;
    result = 37 * result + assets.hashCode;

    return result;
  }

  @override
  bool operator ==(Object other) =>
      other is AquaThemeData && other.hashCode == hashCode;
}

@immutable
class AquaThemedAssets {
  const AquaThemedAssets({
    @required this.suits,
  }) : assert(suits != null);

  final Map<Suit, AssetImage> suits;
}
