import 'package:aqua/src/common_widgets/aqua_theme.dart';
import 'package:aqua/src/constants/card.dart';
import 'package:flutter/services.dart';
import "package:flutter/widgets.dart";
import 'package:poker/poker.dart';

typedef OnRangeSelectorUpdate = void Function(Set<HandRangePart>);

class HandRangeSelectGrid extends StatefulWidget {
  HandRangeSelectGrid({@required this.onUpdate, this.value, Key key})
      : assert(onUpdate != null),
        super(key: key);

  final OnRangeSelectorUpdate onUpdate;

  final Set<HandRangePart> value;

  @override
  State<HandRangeSelectGrid> createState() => _HandRangeSelectGridState();
}

class _HandRangeSelectGridState extends State<HandRangeSelectGrid> {
  Set<HandRangePart> selectedRange;
  bool isToCheck;

  @override
  void initState() {
    super.initState();

    selectedRange = widget.value == null ? {} : widget.value;
  }

  @override
  void didUpdateWidget(HandRangeSelectGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      setState(() {
        selectedRange = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onPanStart: (details) {
            final x = details.localPosition.dx *
                Rank.values.length ~/
                constraints.maxWidth;
            final y = details.localPosition.dy *
                Rank.values.length ~/
                constraints.maxHeight;
            final handRangePart = x > y
                ? HandRangePart(
                    high: ranksInStrongnessOrder[y],
                    kicker: ranksInStrongnessOrder[x],
                    isSuited: true)
                : HandRangePart(
                    high: ranksInStrongnessOrder[x],
                    kicker: ranksInStrongnessOrder[y],
                    isSuited: false);

            isToCheck = !selectedRange.contains(handRangePart);

            if (isToCheck) {
              HapticFeedback.lightImpact();

              setState(() {
                selectedRange.add(handRangePart);
              });

              widget.onUpdate(selectedRange);
            } else {
              HapticFeedback.lightImpact();

              setState(() {
                selectedRange.remove(handRangePart);
              });

              widget.onUpdate(selectedRange);
            }
          },
          onPanUpdate: (details) {
            final x = details.localPosition.dx *
                Rank.values.length ~/
                constraints.maxWidth;
            final y = details.localPosition.dy *
                Rank.values.length ~/
                constraints.maxHeight;

            if (x < 0 || x >= Rank.values.length) return;
            if (y < 0 || y >= Rank.values.length) return;

            final handRangePart = x > y
                ? HandRangePart(
                    high: ranksInStrongnessOrder[y],
                    kicker: ranksInStrongnessOrder[x],
                    isSuited: true)
                : HandRangePart(
                    high: ranksInStrongnessOrder[x],
                    kicker: ranksInStrongnessOrder[y],
                    isSuited: false);

            if (isToCheck) {
              if (selectedRange.contains(handRangePart)) return;

              HapticFeedback.selectionClick();

              setState(() {
                selectedRange.add(handRangePart);
              });

              widget.onUpdate(selectedRange);
            } else {
              if (!selectedRange.contains(handRangePart)) return;

              HapticFeedback.selectionClick();

              setState(() {
                selectedRange.remove(handRangePart);
              });

              widget.onUpdate(selectedRange);
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: List.generate(Rank.values.length * 2 - 1, (i) {
              if (i % 2 == 1) return SizedBox(height: 2);

              final y = i ~/ 2;

              return Expanded(
                child: Row(
                  children: List.generate(Rank.values.length * 2 - 1, (j) {
                    if (j % 2 == 1) return SizedBox(width: 2);

                    final x = j ~/ 2;
                    final handRangePart = x > y
                        ? HandRangePart(
                            high: ranksInStrongnessOrder[y],
                            kicker: ranksInStrongnessOrder[x],
                            isSuited: true,
                          )
                        : HandRangePart(
                            high: ranksInStrongnessOrder[x],
                            kicker: ranksInStrongnessOrder[y],
                            isSuited: false,
                          );

                    return Expanded(
                      child: HandRangeSelectGridItem(
                        handRangePart: handRangePart,
                        isSelected: selectedRange.contains(handRangePart),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      );
}

class HandRangeSelectGridItem extends StatelessWidget {
  HandRangeSelectGridItem({
    @required this.handRangePart,
    this.isSelected = false,
    Key key,
  })  : assert(handRangePart != null),
        super(key: key);

  final HandRangePart handRangePart;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final backgroundColor = isSelected
        ? theme.highlightBackgroundColor
        : handRangePart.isPocket
            ? theme.secondaryBackgroundColor
            : theme.dimBackgroundColor;
    final textColor = isSelected
        ? theme.whiteForegroundColor
        : handRangePart.isPocket
            ? theme.secondaryForegroundColor
            : theme.dimForegroundColor;

    return LayoutBuilder(
      builder: (context, constraints) => DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(
          child: Text(
            '${rankChars[handRangePart.high]}${rankChars[handRangePart.kicker]}',
            style: theme.textStyle.copyWith(
              color: textColor,
              fontSize: constraints.maxWidth / 2,
            ),
          ),
        ),
      ),
    );
  }
}
