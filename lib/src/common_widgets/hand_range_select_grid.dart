import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/fill.dart";
import "package:aqua/src/constants/card.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:poker/poker.dart";

class HandRangeSelectGrid extends StatefulWidget {
  HandRangeSelectGrid({
    Key key,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.value = const {},
  })  : assert(onChanged != null),
        super(key: key);

  final void Function(Set<HandRangePart> handRange) onChanged;

  final void Function(HandRangePart part, bool isToMark) onChangeStart;

  final void Function(HandRangePart part, bool wasToMark) onChangeEnd;

  final Set<HandRangePart> value;

  @override
  State<HandRangeSelectGrid> createState() => _HandRangeSelectGridState();
}

class _HandRangeSelectGridState extends State<HandRangeSelectGrid> {
  Set<HandRangePart> selectedRange;

  bool isToMark;

  HandRangePart lastChangedPart;

  @override
  void initState() {
    super.initState();

    selectedRange = widget.value == null ? {} : {...widget.value};
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
  Widget build(BuildContext context) => Fill(
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
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

                isToMark = !selectedRange.contains(handRangePart);

                if (isToMark) {
                  HapticFeedback.lightImpact();

                  setState(() {
                    selectedRange.add(handRangePart);
                    lastChangedPart = handRangePart;
                  });

                  if (widget.onChangeStart != null) {
                    widget.onChangeStart(handRangePart, true);
                  }

                  widget.onChanged(selectedRange);
                } else {
                  HapticFeedback.lightImpact();

                  setState(() {
                    selectedRange.remove(handRangePart);
                    lastChangedPart = handRangePart;
                  });

                  if (widget.onChangeStart != null) {
                    widget.onChangeStart(handRangePart, false);
                  }

                  widget.onChanged(selectedRange);
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

                if (isToMark) {
                  if (selectedRange.contains(handRangePart)) return;

                  HapticFeedback.selectionClick();

                  setState(() {
                    selectedRange.add(handRangePart);
                    lastChangedPart = handRangePart;
                  });

                  widget.onChanged(selectedRange);
                } else {
                  if (!selectedRange.contains(handRangePart)) return;

                  HapticFeedback.selectionClick();

                  setState(() {
                    selectedRange.remove(handRangePart);
                    lastChangedPart = handRangePart;
                  });

                  widget.onChanged(selectedRange);
                }
              },
              onPanEnd: (details) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd(lastChangedPart, isToMark);
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
    final style = AquaTheme.of(context).handRangeGridStyle;

    return LayoutBuilder(
      builder: (context, constraints) => DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected
              ? style.selectedBackgroundColor
              : style.backgroundColor,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(
          child: Text(
            "${rankChars[handRangePart.high]}${rankChars[handRangePart.kicker]}",
            style: style.textStyle.copyWith(
              color: isSelected
                  ? style.selectedForegroundColor
                  : style.textStyle.color,
              fontSize: constraints.maxWidth / 2,
            ),
          ),
        ),
      ),
    );
  }
}
