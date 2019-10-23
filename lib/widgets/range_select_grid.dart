import "package:flutter/widgets.dart";
import '../models/card.dart';
import "../models/hand_range_part.dart" show HandRangePart;

typedef OnRangeSelectorUpdate = void Function(Set<HandRangePart>);

class RangeSelectGrid extends StatefulWidget {
  RangeSelectGrid({Key key, @required this.onUpdate, this.initial})
      : assert(onUpdate != null),
        super(key: key);

  final OnRangeSelectorUpdate onUpdate;

  final Set<HandRangePart> initial;

  @override
  State<RangeSelectGrid> createState() => _RangeSelectGridState();
}

class _RangeSelectGridState extends State<RangeSelectGrid> {
  Set<HandRangePart> selectedRange;
  bool isToCheck;

  @override
  void initState() {
    super.initState();

    selectedRange = widget.initial == null ? {} : widget.initial;
  }

  void _onPanEnd() {
    widget.onUpdate(selectedRange);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onPanStart: (details) {
            final x = details.localPosition.dx *
                _matrix[0].length ~/
                constraints.maxWidth;
            final y = details.localPosition.dy *
                _matrix.length ~/
                constraints.maxHeight;

            isToCheck = !selectedRange.contains(_matrix[y][x]);

            if (isToCheck) {
              setState(() {
                selectedRange.add(_matrix[y][x]);
              });
            } else {
              setState(() {
                selectedRange.remove(_matrix[y][x]);
              });
            }
          },
          onPanUpdate: (details) {
            final x = details.localPosition.dx *
                _matrix[0].length ~/
                constraints.maxWidth;
            final y = details.localPosition.dy *
                _matrix.length ~/
                constraints.maxHeight;

            if (x < 0 || x >= _matrix[0].length) return;
            if (y < 0 || y >= _matrix.length) return;

            if (isToCheck) {
              setState(() {
                selectedRange.add(_matrix[y][x]);
              });
            } else {
              setState(() {
                selectedRange.remove(_matrix[y][x]);
              });
            }
          },
          onPanEnd: (_) => _onPanEnd(),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: List.generate(_matrix.length * 2 - 1, (i) {
              if (i % 2 == 1) return SizedBox(height: 2);

              final y = i ~/ 2;

              return Expanded(
                child: Row(
                  children: List.generate(_matrix[y].length * 2 - 1, (j) {
                    if (j % 2 == 1) return SizedBox(width: 2);

                    final x = j ~/ 2;
                    final rangePart = _matrix[y][x];

                    Color cellColor = const Color(0xffdfe6ed);
                    Color textColor = const Color(0xff464655);

                    if (rangePart.high == rangePart.kicker) {
                      // cellColor = const Color(0x7f00d2d3);
                      // textColor = const Color(0xff01a3a4);
                      cellColor = const Color(0x7ffeca57);
                      textColor = const Color(0xffff9f43);
                    }

                    // if (rangePart.isSuited) {
                    //   cellColor = const Color(0x7ffeca57);
                    //   textColor = const Color(0xffff9f43);
                    // }

                    if (selectedRange.contains(rangePart)) {
                      cellColor = const Color(0x3f1dd1a1);
                      textColor = const Color(0xff10ac84);
                    }

                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: cellColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        height: constraints.maxWidth / _matrix[y].length,
                        child: Center(
                          child: Text(
                            '${_rankStrings[_matrix[y][x].high]}${_rankStrings[_matrix[y][x].kicker]}',
                            style: TextStyle(
                              color: textColor,
                              fontFamily: "WorkSans",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

const _matrix = [
  [
    HandRangePart(high: Rank.ace, kicker: Rank.ace, isSuited: false),
    HandRangePart(high: Rank.ace, kicker: Rank.king, isSuited: true),
    HandRangePart(high: Rank.ace, kicker: Rank.queen, isSuited: true),
    HandRangePart(high: Rank.ace, kicker: Rank.jack, isSuited: true),
    HandRangePart(high: Rank.ace, kicker: Rank.ten, isSuited: true),
    HandRangePart(high: Rank.ace, kicker: Rank.nine, isSuited: true),
    HandRangePart(high: Rank.ace, kicker: Rank.eight, isSuited: true),
    HandRangePart(high: Rank.ace, kicker: Rank.seven, isSuited: true),
    HandRangePart(high: Rank.ace, kicker: Rank.six, isSuited: true),
    HandRangePart(high: Rank.ace, kicker: Rank.five, isSuited: true),
    HandRangePart(high: Rank.ace, kicker: Rank.four, isSuited: true),
    HandRangePart(high: Rank.ace, kicker: Rank.three, isSuited: true),
    HandRangePart(high: Rank.ace, kicker: Rank.two, isSuited: true),
  ],
  [
    HandRangePart(high: Rank.ace, kicker: Rank.king, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.king, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.queen, isSuited: true),
    HandRangePart(high: Rank.king, kicker: Rank.jack, isSuited: true),
    HandRangePart(high: Rank.king, kicker: Rank.ten, isSuited: true),
    HandRangePart(high: Rank.king, kicker: Rank.nine, isSuited: true),
    HandRangePart(high: Rank.king, kicker: Rank.eight, isSuited: true),
    HandRangePart(high: Rank.king, kicker: Rank.seven, isSuited: true),
    HandRangePart(high: Rank.king, kicker: Rank.six, isSuited: true),
    HandRangePart(high: Rank.king, kicker: Rank.five, isSuited: true),
    HandRangePart(high: Rank.king, kicker: Rank.four, isSuited: true),
    HandRangePart(high: Rank.king, kicker: Rank.three, isSuited: true),
    HandRangePart(high: Rank.king, kicker: Rank.two, isSuited: true),
  ],
  [
    HandRangePart(high: Rank.ace, kicker: Rank.queen, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.queen, isSuited: false),
    HandRangePart(high: Rank.queen, kicker: Rank.queen, isSuited: false),
    HandRangePart(high: Rank.queen, kicker: Rank.jack, isSuited: true),
    HandRangePart(high: Rank.queen, kicker: Rank.ten, isSuited: true),
    HandRangePart(high: Rank.queen, kicker: Rank.nine, isSuited: true),
    HandRangePart(high: Rank.queen, kicker: Rank.eight, isSuited: true),
    HandRangePart(high: Rank.queen, kicker: Rank.seven, isSuited: true),
    HandRangePart(high: Rank.queen, kicker: Rank.six, isSuited: true),
    HandRangePart(high: Rank.queen, kicker: Rank.five, isSuited: true),
    HandRangePart(high: Rank.queen, kicker: Rank.four, isSuited: true),
    HandRangePart(high: Rank.queen, kicker: Rank.three, isSuited: true),
    HandRangePart(high: Rank.queen, kicker: Rank.two, isSuited: true),
  ],
  [
    HandRangePart(high: Rank.ace, kicker: Rank.jack, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.jack, isSuited: false),
    HandRangePart(high: Rank.queen, kicker: Rank.jack, isSuited: false),
    HandRangePart(high: Rank.jack, kicker: Rank.jack, isSuited: false),
    HandRangePart(high: Rank.jack, kicker: Rank.ten, isSuited: true),
    HandRangePart(high: Rank.jack, kicker: Rank.nine, isSuited: true),
    HandRangePart(high: Rank.jack, kicker: Rank.eight, isSuited: true),
    HandRangePart(high: Rank.jack, kicker: Rank.seven, isSuited: true),
    HandRangePart(high: Rank.jack, kicker: Rank.six, isSuited: true),
    HandRangePart(high: Rank.jack, kicker: Rank.five, isSuited: true),
    HandRangePart(high: Rank.jack, kicker: Rank.four, isSuited: true),
    HandRangePart(high: Rank.jack, kicker: Rank.three, isSuited: true),
    HandRangePart(high: Rank.jack, kicker: Rank.two, isSuited: true),
  ],
  [
    HandRangePart(high: Rank.ace, kicker: Rank.ten, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.ten, isSuited: false),
    HandRangePart(high: Rank.queen, kicker: Rank.ten, isSuited: false),
    HandRangePart(high: Rank.jack, kicker: Rank.ten, isSuited: false),
    HandRangePart(high: Rank.ten, kicker: Rank.ten, isSuited: false),
    HandRangePart(high: Rank.ten, kicker: Rank.nine, isSuited: true),
    HandRangePart(high: Rank.ten, kicker: Rank.eight, isSuited: true),
    HandRangePart(high: Rank.ten, kicker: Rank.seven, isSuited: true),
    HandRangePart(high: Rank.ten, kicker: Rank.six, isSuited: true),
    HandRangePart(high: Rank.ten, kicker: Rank.five, isSuited: true),
    HandRangePart(high: Rank.ten, kicker: Rank.four, isSuited: true),
    HandRangePart(high: Rank.ten, kicker: Rank.three, isSuited: true),
    HandRangePart(high: Rank.ten, kicker: Rank.two, isSuited: true),
  ],
  [
    HandRangePart(high: Rank.ace, kicker: Rank.nine, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.nine, isSuited: false),
    HandRangePart(high: Rank.queen, kicker: Rank.nine, isSuited: false),
    HandRangePart(high: Rank.jack, kicker: Rank.nine, isSuited: false),
    HandRangePart(high: Rank.ten, kicker: Rank.nine, isSuited: false),
    HandRangePart(high: Rank.nine, kicker: Rank.nine, isSuited: false),
    HandRangePart(high: Rank.nine, kicker: Rank.eight, isSuited: true),
    HandRangePart(high: Rank.nine, kicker: Rank.seven, isSuited: true),
    HandRangePart(high: Rank.nine, kicker: Rank.six, isSuited: true),
    HandRangePart(high: Rank.nine, kicker: Rank.five, isSuited: true),
    HandRangePart(high: Rank.nine, kicker: Rank.four, isSuited: true),
    HandRangePart(high: Rank.nine, kicker: Rank.three, isSuited: true),
    HandRangePart(high: Rank.nine, kicker: Rank.two, isSuited: true),
  ],
  [
    HandRangePart(high: Rank.ace, kicker: Rank.eight, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.eight, isSuited: false),
    HandRangePart(high: Rank.queen, kicker: Rank.eight, isSuited: false),
    HandRangePart(high: Rank.jack, kicker: Rank.eight, isSuited: false),
    HandRangePart(high: Rank.ten, kicker: Rank.eight, isSuited: false),
    HandRangePart(high: Rank.nine, kicker: Rank.eight, isSuited: false),
    HandRangePart(high: Rank.eight, kicker: Rank.eight, isSuited: false),
    HandRangePart(high: Rank.eight, kicker: Rank.seven, isSuited: true),
    HandRangePart(high: Rank.eight, kicker: Rank.six, isSuited: true),
    HandRangePart(high: Rank.eight, kicker: Rank.five, isSuited: true),
    HandRangePart(high: Rank.eight, kicker: Rank.four, isSuited: true),
    HandRangePart(high: Rank.eight, kicker: Rank.three, isSuited: true),
    HandRangePart(high: Rank.eight, kicker: Rank.two, isSuited: true),
  ],
  [
    HandRangePart(high: Rank.ace, kicker: Rank.seven, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.seven, isSuited: false),
    HandRangePart(high: Rank.queen, kicker: Rank.seven, isSuited: false),
    HandRangePart(high: Rank.jack, kicker: Rank.seven, isSuited: false),
    HandRangePart(high: Rank.ten, kicker: Rank.seven, isSuited: false),
    HandRangePart(high: Rank.nine, kicker: Rank.seven, isSuited: false),
    HandRangePart(high: Rank.eight, kicker: Rank.seven, isSuited: false),
    HandRangePart(high: Rank.seven, kicker: Rank.seven, isSuited: false),
    HandRangePart(high: Rank.seven, kicker: Rank.six, isSuited: true),
    HandRangePart(high: Rank.seven, kicker: Rank.five, isSuited: true),
    HandRangePart(high: Rank.seven, kicker: Rank.four, isSuited: true),
    HandRangePart(high: Rank.seven, kicker: Rank.three, isSuited: true),
    HandRangePart(high: Rank.seven, kicker: Rank.two, isSuited: true),
  ],
  [
    HandRangePart(high: Rank.ace, kicker: Rank.six, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.six, isSuited: false),
    HandRangePart(high: Rank.queen, kicker: Rank.six, isSuited: false),
    HandRangePart(high: Rank.jack, kicker: Rank.six, isSuited: false),
    HandRangePart(high: Rank.ten, kicker: Rank.six, isSuited: false),
    HandRangePart(high: Rank.nine, kicker: Rank.six, isSuited: false),
    HandRangePart(high: Rank.eight, kicker: Rank.six, isSuited: false),
    HandRangePart(high: Rank.seven, kicker: Rank.six, isSuited: false),
    HandRangePart(high: Rank.six, kicker: Rank.six, isSuited: false),
    HandRangePart(high: Rank.six, kicker: Rank.five, isSuited: true),
    HandRangePart(high: Rank.six, kicker: Rank.four, isSuited: true),
    HandRangePart(high: Rank.six, kicker: Rank.three, isSuited: true),
    HandRangePart(high: Rank.six, kicker: Rank.two, isSuited: true),
  ],
  [
    HandRangePart(high: Rank.ace, kicker: Rank.five, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.five, isSuited: false),
    HandRangePart(high: Rank.queen, kicker: Rank.five, isSuited: false),
    HandRangePart(high: Rank.jack, kicker: Rank.five, isSuited: false),
    HandRangePart(high: Rank.ten, kicker: Rank.five, isSuited: false),
    HandRangePart(high: Rank.nine, kicker: Rank.five, isSuited: false),
    HandRangePart(high: Rank.eight, kicker: Rank.five, isSuited: false),
    HandRangePart(high: Rank.seven, kicker: Rank.five, isSuited: false),
    HandRangePart(high: Rank.six, kicker: Rank.five, isSuited: false),
    HandRangePart(high: Rank.five, kicker: Rank.five, isSuited: false),
    HandRangePart(high: Rank.four, kicker: Rank.four, isSuited: true),
    HandRangePart(high: Rank.four, kicker: Rank.three, isSuited: true),
    HandRangePart(high: Rank.four, kicker: Rank.two, isSuited: true),
  ],
  [
    HandRangePart(high: Rank.ace, kicker: Rank.four, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.four, isSuited: false),
    HandRangePart(high: Rank.queen, kicker: Rank.four, isSuited: false),
    HandRangePart(high: Rank.jack, kicker: Rank.four, isSuited: false),
    HandRangePart(high: Rank.ten, kicker: Rank.four, isSuited: false),
    HandRangePart(high: Rank.nine, kicker: Rank.four, isSuited: false),
    HandRangePart(high: Rank.eight, kicker: Rank.four, isSuited: false),
    HandRangePart(high: Rank.seven, kicker: Rank.four, isSuited: false),
    HandRangePart(high: Rank.six, kicker: Rank.four, isSuited: false),
    HandRangePart(high: Rank.five, kicker: Rank.four, isSuited: false),
    HandRangePart(high: Rank.four, kicker: Rank.four, isSuited: false),
    HandRangePart(high: Rank.four, kicker: Rank.three, isSuited: true),
    HandRangePart(high: Rank.four, kicker: Rank.two, isSuited: true),
  ],
  [
    HandRangePart(high: Rank.ace, kicker: Rank.three, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.three, isSuited: false),
    HandRangePart(high: Rank.queen, kicker: Rank.three, isSuited: false),
    HandRangePart(high: Rank.jack, kicker: Rank.three, isSuited: false),
    HandRangePart(high: Rank.ten, kicker: Rank.three, isSuited: false),
    HandRangePart(high: Rank.nine, kicker: Rank.three, isSuited: false),
    HandRangePart(high: Rank.eight, kicker: Rank.three, isSuited: false),
    HandRangePart(high: Rank.seven, kicker: Rank.three, isSuited: false),
    HandRangePart(high: Rank.six, kicker: Rank.three, isSuited: false),
    HandRangePart(high: Rank.five, kicker: Rank.three, isSuited: false),
    HandRangePart(high: Rank.four, kicker: Rank.three, isSuited: false),
    HandRangePart(high: Rank.three, kicker: Rank.three, isSuited: false),
    HandRangePart(high: Rank.four, kicker: Rank.two, isSuited: true),
  ],
  [
    HandRangePart(high: Rank.ace, kicker: Rank.two, isSuited: false),
    HandRangePart(high: Rank.king, kicker: Rank.two, isSuited: false),
    HandRangePart(high: Rank.queen, kicker: Rank.two, isSuited: false),
    HandRangePart(high: Rank.jack, kicker: Rank.two, isSuited: false),
    HandRangePart(high: Rank.ten, kicker: Rank.two, isSuited: false),
    HandRangePart(high: Rank.nine, kicker: Rank.two, isSuited: false),
    HandRangePart(high: Rank.eight, kicker: Rank.two, isSuited: false),
    HandRangePart(high: Rank.seven, kicker: Rank.two, isSuited: false),
    HandRangePart(high: Rank.six, kicker: Rank.two, isSuited: false),
    HandRangePart(high: Rank.five, kicker: Rank.two, isSuited: false),
    HandRangePart(high: Rank.four, kicker: Rank.two, isSuited: false),
    HandRangePart(high: Rank.three, kicker: Rank.two, isSuited: false),
    HandRangePart(high: Rank.two, kicker: Rank.two, isSuited: false),
  ],
];

const _rankStrings = {
  Rank.ace: "A",
  Rank.king: "K",
  Rank.queen: "Q",
  Rank.jack: "J",
  Rank.ten: "T",
  Rank.nine: "9",
  Rank.eight: "8",
  Rank.seven: "7",
  Rank.six: "6",
  Rank.five: "5",
  Rank.four: "4",
  Rank.three: "3",
  Rank.two: "2",
};
