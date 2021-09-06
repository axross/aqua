import "package:flutter/foundation.dart";
import "package:poker/poker.dart";

class CardPairDraft extends ChangeNotifier {
  CardPairDraft(this._a, this._b) : assert(_a != _b);

  CardPairDraft.empty();

  Card? _a;

  Card? _b;

  bool get isComplete => _a != null && _b != null;

  @override
  int get hashCode {
    int result = 17;

    result = 37 * result + _a.hashCode;
    result = 37 * result + _b.hashCode;

    return result;
  }

  CardPair toCardPair() {
    assert(isComplete);

    return CardPair(_a!, _b!);
  }

  /// Returns a string representation such like `"AsKh"`.
  @override
  String toString() => "$_a$_b";

  Card? operator [](int index) {
    assert(index == 0 || index == 1, "index should 0 or 1.");

    return index == 0 ? _a : _b;
  }

  operator []=(int index, Card? card) {
    assert(index == 0 || index == 1, "index should 0 or 1.");

    if (index == 0) {
      _a = card;
    } else {
      _b = card;
    }

    notifyListeners();
  }

  @override
  operator ==(Object other) =>
      other is CardPairDraft && other._a == _a && other._b == _b;
}
