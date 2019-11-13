import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/rank.dart';
import 'package:flutter/widgets.dart';

class ReadonlyRangeGrid extends StatelessWidget {
  ReadonlyRangeGrid({@required this.handRange, Key key})
      : assert(handRange != null),
        super(key: key);

  final Set<HandRangePart> handRange;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => DecoratedBox(
        decoration: BoxDecoration(
          color: theme.dimBackgroundColor,
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
                          ? theme.highlightBackgroundColor
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
