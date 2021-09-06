import "package:flutter/painting.dart";
import "package:flutter/services.dart";

void setSystemUIOverlayStyle({
  required Color topColor,
  Color? bottomColor,
}) {
  final topBrightness = _estimateBrightness(topColor);
  final bottomBrightness = _estimateBrightness(topColor);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: topBrightness,
    statusBarColor: topColor,
    statusBarIconBrightness: _opposite(topBrightness),
    systemNavigationBarColor: bottomColor ?? topColor,
    systemNavigationBarIconBrightness: _opposite(bottomBrightness),
  ));
}

Brightness _opposite(Brightness brightness) =>
    brightness == Brightness.light ? Brightness.dark : Brightness.light;

Brightness _estimateBrightness(Color color) {
  final double relativeLuminance = color.computeLuminance();

  // See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
  // The spec says to use kThreshold=0.0525, but Material Design appears to bias
  // more towards using light text than WCAG20 recommends. Material Design spec
  // doesn't say what value to use, but 0.15 seemed close to what the Material
  // Design spec shows for its color palette on
  // <https://material.io/go/design-theming#color-color-palette>.
  const double kThreshold = 0.15;

  return (relativeLuminance + 0.05) * (relativeLuminance + 0.05) > kThreshold
      ? Brightness.light
      : Brightness.dark;
}
