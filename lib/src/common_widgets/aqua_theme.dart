import "package:aqua/src/common_widgets/aqua_button.dart";
import "package:aqua/src/common_widgets/aqua_scaffold.dart";
import "package:aqua/src/common_widgets/digits_text.dart";
import "package:flutter/widgets.dart";
import "package:poker/poker.dart";

class AquaTheme extends InheritedWidget {
  AquaTheme({
    @required this.data,
    Widget child,
    Key key,
  })  : assert(data != null),
        super(
          key: key,
          child: DefaultAquaButtonStyle(
            style: data.buttonStyleSet.normal,
            child: child,
          ),
        );

  final AquaThemeData data;

  @override
  bool updateShouldNotify(AquaTheme old) => data != old.data;

  static AquaThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AquaTheme>().data;
}

@immutable
class AquaThemeData {
  const AquaThemeData({
    @required this.textStyleSet,
    @required this.buttonStyleSet,
    @required this.scaffoldStyle,
    @required this.playingCardStyle,
    @required this.handRangeGridStyle,
    @required this.digitTextStyle,
    @required this.sliderStyle,
    @required this.cursorColor,
  });

  final AquaTextStyleSet textStyleSet;

  final AquaButtonStyleSet buttonStyleSet;

  final AquaScaffoldStyle scaffoldStyle;

  final AquaPlayingCardStyle playingCardStyle;

  final AquaHandRangeGridStyle handRangeGridStyle;

  final AquaDigitTextStyle digitTextStyle;

  final AquaSliderStyle sliderStyle;

  final Color cursorColor;
}

@immutable
class AquaTextStyleSet {
  const AquaTextStyleSet({
    @required this.headline,
    @required this.body,
    @required this.caption,
    @required this.errorCaption,
  })  : assert(headline != null),
        assert(body != null),
        assert(caption != null),
        assert(errorCaption != null);

  final TextStyle headline;

  final TextStyle body;

  final TextStyle caption;

  final TextStyle errorCaption;
}

class AquaPlayingCardStyle {
  const AquaPlayingCardStyle({
    @required this.textStyle,
    @required this.backgroundColor,
    @required this.suitColors,
  })  : assert(textStyle != null),
        assert(backgroundColor != null),
        assert(suitColors != null);

  final TextStyle textStyle;

  final Color backgroundColor;

  final Map<Suit, Color> suitColors;
}

class AquaHandRangeGridStyle {
  AquaHandRangeGridStyle({
    @required this.backgroundColor,
    @required this.textStyle,
    @required this.selectedBackgroundColor,
    @required this.selectedForegroundColor,
  })  : assert(backgroundColor != null),
        assert(textStyle != null),
        assert(selectedBackgroundColor != null),
        assert(selectedForegroundColor != null);

  final Color backgroundColor;

  final TextStyle textStyle;

  final Color selectedBackgroundColor;

  final Color selectedForegroundColor;
}

class AquaSliderStyle {
  AquaSliderStyle({
    @required this.thumbColor,
    @required this.activeTrackColor,
    @required this.inactiveTrackColor,
    @required this.valueIndicatorColor,
    @required this.valueIndicatorTextStyle,
  })  : assert(thumbColor != null),
        assert(activeTrackColor != null),
        assert(inactiveTrackColor != null),
        assert(valueIndicatorColor != null),
        assert(valueIndicatorTextStyle != null);

  final Color thumbColor;

  final Color activeTrackColor;

  final Color inactiveTrackColor;

  final Color valueIndicatorColor;

  final TextStyle valueIndicatorTextStyle;
}
