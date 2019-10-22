import '../models/card.dart' show Rank;
import '../models/hand_range_part.dart' show HandRangePart;
import 'package:flutter/widgets.dart';

class ReadonlyRangeGrid extends StatelessWidget {
  ReadonlyRangeGrid({@required this.handRange, Key key})
      : assert(handRange != null),
        super(key: key);

  final Set<HandRangePart> handRange;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xffdfe6ed),
          borderRadius: BorderRadius.circular(constraints.maxWidth * 0.05),
        ),
        child: Table(
          children: List.generate(_ranksInStrongnessOrder.length, (row) {
            return TableRow(
              children: List.generate(_ranksInStrongnessOrder.length, (column) {
                final high = row < column ? row : column;
                final kicker = high == row ? column : row;
                final handRangePart = HandRangePart(
                  high: _ranksInStrongnessOrder[high],
                  kicker: _ranksInStrongnessOrder[kicker],
                  isSuited: row < column,
                );
                BorderRadius borderRadius;

                if (row == 0 && column == 0) {
                  borderRadius = BorderRadius.only(
                      topLeft: Radius.circular(constraints.maxWidth * 0.05));
                }

                if (row == 0 && column == _ranksInStrongnessOrder.length - 1) {
                  borderRadius = BorderRadius.only(
                      topRight: Radius.circular(constraints.maxWidth * 0.05));
                }

                if (row == _ranksInStrongnessOrder.length - 1 && column == 0) {
                  borderRadius = BorderRadius.only(
                      bottomLeft: Radius.circular(constraints.maxWidth * 0.05));
                }

                if (row == _ranksInStrongnessOrder.length - 1 &&
                    column == _ranksInStrongnessOrder.length - 1) {
                  borderRadius = BorderRadius.only(
                      bottomRight:
                          Radius.circular(constraints.maxWidth * 0.05));
                }

                return TableCell(
                  child: Container(
                    height: constraints.maxWidth / 13,
                    decoration: BoxDecoration(
                      color: handRange.contains(handRangePart)
                          ? Color(0x7f1dd1a1)
                          : null,
                      borderRadius: borderRadius,
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}

const _ranksInStrongnessOrder = [
  Rank.ace,
  Rank.king,
  Rank.queen,
  Rank.jack,
  Rank.ten,
  Rank.nine,
  Rank.eight,
  Rank.seven,
  Rank.six,
  Rank.five,
  Rank.four,
  Rank.three,
  Rank.two,
];
