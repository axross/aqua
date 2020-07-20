import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/constants/card.dart";
import "package:flutter/widgets.dart";
import "package:poker/poker.dart";

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
          children: List.generate(ranksInStrongnessOrder.length, (row) {
            return TableRow(
              children: List.generate(ranksInStrongnessOrder.length, (column) {
                final high = row < column ? row : column;
                final kicker = high == row ? column : row;
                final handRangePart = HandRangePart(
                  high: ranksInStrongnessOrder[high],
                  kicker: ranksInStrongnessOrder[kicker],
                  isSuited: row < column,
                );
                BorderRadius borderRadius;

                if (row == 0 && column == 0) {
                  borderRadius = BorderRadius.only(
                      topLeft: Radius.circular(constraints.maxWidth * 0.05));
                }

                if (row == 0 && column == ranksInStrongnessOrder.length - 1) {
                  borderRadius = BorderRadius.only(
                      topRight: Radius.circular(constraints.maxWidth * 0.05));
                }

                if (row == ranksInStrongnessOrder.length - 1 && column == 0) {
                  borderRadius = BorderRadius.only(
                      bottomLeft: Radius.circular(constraints.maxWidth * 0.05));
                }

                if (row == ranksInStrongnessOrder.length - 1 &&
                    column == ranksInStrongnessOrder.length - 1) {
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
