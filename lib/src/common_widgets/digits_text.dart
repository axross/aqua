import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:flutter/widgets.dart";

class DigitsText extends StatelessWidget {
  DigitsText(
    this.value, {
    this.style,
    this.textStyle,
    this.useLargeWholeNumberPart = true,
    this.suffix = "%",
    this.fractionDigits = 2,
    this.showAlmostEqualPrefix = false,
  }) : assert(value != null);

  final double value;

  final AquaDigitTextStyle style;

  final TextStyle textStyle;

  final bool useLargeWholeNumberPart;

  final String suffix;

  final int fractionDigits;

  final bool showAlmostEqualPrefix;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final textStyle = this.textStyle ?? DefaultTextStyle.of(context).style;
    final style = this.style ?? theme.digitTextStyle;

    return RichText(
      text: TextSpan(
        children: [
          if (fractionDigits == 0 &&
              showAlmostEqualPrefix &&
              value % 1 != 0) ...[
            TextSpan(
              text: "≈ ",
              style: textStyle
                  .copyWith(
                    color: this.textStyle?.color ?? style.color,
                    fontFamily: this.textStyle?.fontFamily ?? style.fontFamily,
                    fontWeight: this.textStyle?.fontWeight ?? style.fontWeight,
                  )
                  .apply(fontSizeFactor: style.fontSizeFactor),
            ),
          ],
          TextSpan(
            text: "${(value * 100).toInt()}",
            style: textStyle
                .copyWith(
                  color: this.textStyle?.color ?? style.color,
                  fontFamily: this.textStyle?.fontFamily ?? style.fontFamily,
                  fontWeight: this.textStyle?.fontWeight ?? style.fontWeight,
                )
                .apply(
                  fontSizeFactor: useLargeWholeNumberPart
                      ? style.largeFontSizeFactor
                      : style.fontSizeFactor,
                ),
          ),
          if (fractionDigits > 0) ...[
            TextSpan(
              text: ".",
              style: textStyle
                  .copyWith(
                    color: this.textStyle?.color ?? style.color,
                    fontFamily: this.textStyle?.fontFamily ?? style.fontFamily,
                    fontWeight: this.textStyle?.fontWeight ?? style.fontWeight,
                  )
                  .apply(fontSizeFactor: style.fontSizeFactor),
            ),
            TextSpan(
              text:
                  "${extractDecimalPartOf(value, fractionDigits: fractionDigits)}"
                      .padLeft(fractionDigits, "0"),
              style: textStyle
                  .copyWith(
                    color: this.textStyle?.color ?? style.color,
                    fontFamily: this.textStyle?.fontFamily ?? style.fontFamily,
                    fontWeight: this.textStyle?.fontWeight ?? style.fontWeight,
                  )
                  .apply(fontSizeFactor: style.fontSizeFactor),
            ),
          ],
          TextSpan(
            text: suffix,
            style: textStyle
                .copyWith(
                  color: this.textStyle?.color ?? style.color,
                  fontFamily: this.textStyle?.fontFamily ?? style.fontFamily,
                  // fontWeight: this.textStyle?.fontWeight ?? style.fontWeight,
                )
                .apply(fontSizeFactor: style.fontSizeFactor),
          ),
        ],
      ),
    );
  }
}

int extractDecimalPartOf(double value, {@required int fractionDigits}) {
  var onlyDecimalPart = value % 1;
  int asWholeNumber = 0;

  for (int d = 0; d < fractionDigits; ++d) {
    onlyDecimalPart = onlyDecimalPart * 10;
    asWholeNumber = asWholeNumber * 10 + onlyDecimalPart.toInt();

    onlyDecimalPart = onlyDecimalPart % 1;
  }

  return asWholeNumber;
}

class DigitsPlaceholderText extends StatelessWidget {
  DigitsPlaceholderText({
    this.style,
    this.textStyle,
    this.useLargeWholeNumberPart = true,
    this.suffix = "%",
    this.fractionDigits = 2,
  });

  final AquaDigitTextStyle style;

  final TextStyle textStyle;

  final bool useLargeWholeNumberPart;

  final String suffix;

  final int fractionDigits;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final textStyle = this.textStyle ?? DefaultTextStyle.of(context).style;
    final style = this.style ?? theme.digitTextStyle;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "??",
            style: textStyle
                .copyWith(
                  color: this.textStyle?.color ?? style.placeholderColor,
                  fontFamily: this.textStyle?.fontFamily ?? style.fontFamily,
                  fontWeight: this.textStyle?.fontWeight ?? style.fontWeight,
                )
                .apply(
                  fontSizeFactor: useLargeWholeNumberPart
                      ? style.largeFontSizeFactor
                      : style.fontSizeFactor,
                ),
          ),
          if (fractionDigits > 0) ...[
            TextSpan(
              text: ".",
              style: textStyle
                  .copyWith(
                    color: this.textStyle?.color ?? style.placeholderColor,
                    fontFamily: this.textStyle?.fontFamily ?? style.fontFamily,
                    fontWeight: this.textStyle?.fontWeight ?? style.fontWeight,
                  )
                  .apply(fontSizeFactor: style.fontSizeFactor),
            ),
            TextSpan(
              text: "".padLeft(fractionDigits, "?"),
              style: textStyle
                  .copyWith(
                    color: this.textStyle?.color ?? style.placeholderColor,
                    fontFamily: this.textStyle?.fontFamily ?? style.fontFamily,
                    fontWeight: this.textStyle?.fontWeight ?? style.fontWeight,
                  )
                  .apply(fontSizeFactor: style.fontSizeFactor),
            ),
          ],
          TextSpan(
            text: suffix,
            style: textStyle
                .copyWith(
                  color: this.textStyle?.color ?? style.placeholderColor,
                  fontFamily: this.textStyle?.fontFamily ?? style.fontFamily,
                  // fontWeight: this.textStyle?.fontWeight ?? style.fontWeight,
                )
                .apply(fontSizeFactor: style.fontSizeFactor),
          ),
        ],
      ),
    );
  }
}

class AquaDigitTextStyle {
  AquaDigitTextStyle({
    @required this.color,
    @required this.placeholderColor,
    @required this.fontFamily,
    @required this.fontWeight,
    @required this.fontSizeFactor,
    @required this.largeFontSizeFactor,
  })  : assert(color != null),
        assert(placeholderColor != null),
        assert(fontFamily != null),
        assert(fontWeight != null),
        assert(fontSizeFactor != null),
        assert(largeFontSizeFactor != null);

  final Color color;

  final Color placeholderColor;

  final String fontFamily;

  final FontWeight fontWeight;

  final double fontSizeFactor;

  final double largeFontSizeFactor;
}
