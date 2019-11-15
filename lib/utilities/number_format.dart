String formatOnlyWholeNumberPart(double value) => "${(value * 100).floor()}";

String formatOnlyWholeNumberPartWithPrefix(double value) {
  final percentage = value * 100;
  int wholeNumberPart = percentage.floor();
  double fractionalPart = percentage - wholeNumberPart;

  if (fractionalPart < 0.0010) {
    fractionalPart = 0;
  }

  if (fractionalPart > 0.9990) {
    wholeNumberPart += 1;
    fractionalPart = 0;
  }

  final prefix = fractionalPart == 0 ? "" : "≈";

  return "$prefix$wholeNumberPart";
}

String formatOnlyFractionalPart(double value) {
  final fractionalPartOfPercentage = (value * 10000 % 100).floor();

  return fractionalPartOfPercentage < 10
      ? "0$fractionalPartOfPercentage"
      : "$fractionalPartOfPercentage";
}
