import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/fill.dart";
import "package:aqua/src/constants/card.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:poker/poker.dart";

class RankPairSelectGrid extends StatefulWidget {
  RankPairSelectGrid({
    Key key,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.value = const {},
  })  : assert(onChanged != null),
        super(key: key);

  final void Function(Set<RankPair> rankPairs) onChanged;

  final void Function(RankPair part, bool isToMark) onChangeStart;

  final void Function(RankPair part, bool wasToMark) onChangeEnd;

  final Set<RankPair> value;

  @override
  State<RankPairSelectGrid> createState() => _RankPairSelectGridState();
}

class _RankPairSelectGridState extends State<RankPairSelectGrid> {
  Set<RankPair> selectedRange;

  bool isToMark;

  RankPair lastChangedPart;

  @override
  void initState() {
    super.initState();

    selectedRange = widget.value == null ? {} : {...widget.value};
  }

  @override
  void didUpdateWidget(RankPairSelectGrid oldWidget) {
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
                final rankPairsPart = x > y
                    ? RankPair.suited(
                        high: ranksInStrongnessOrder[y],
                        kicker: ranksInStrongnessOrder[x],
                      )
                    : RankPair.ofsuit(
                        high: ranksInStrongnessOrder[x],
                        kicker: ranksInStrongnessOrder[y],
                      );

                isToMark = !selectedRange.contains(rankPairsPart);

                if (isToMark) {
                  HapticFeedback.lightImpact();

                  setState(() {
                    selectedRange.add(rankPairsPart);
                    lastChangedPart = rankPairsPart;
                  });

                  if (widget.onChangeStart != null) {
                    widget.onChangeStart(rankPairsPart, true);
                  }

                  widget.onChanged(selectedRange);
                } else {
                  HapticFeedback.lightImpact();

                  setState(() {
                    selectedRange.remove(rankPairsPart);
                    lastChangedPart = rankPairsPart;
                  });

                  if (widget.onChangeStart != null) {
                    widget.onChangeStart(rankPairsPart, false);
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

                final rankPairsPart = x > y
                    ? RankPair.suited(
                        high: ranksInStrongnessOrder[y],
                        kicker: ranksInStrongnessOrder[x],
                      )
                    : RankPair.ofsuit(
                        high: ranksInStrongnessOrder[x],
                        kicker: ranksInStrongnessOrder[y],
                      );

                if (isToMark) {
                  if (selectedRange.contains(rankPairsPart)) return;

                  HapticFeedback.selectionClick();

                  setState(() {
                    selectedRange.add(rankPairsPart);
                    lastChangedPart = rankPairsPart;
                  });

                  widget.onChanged(selectedRange);
                } else {
                  if (!selectedRange.contains(rankPairsPart)) return;

                  HapticFeedback.selectionClick();

                  setState(() {
                    selectedRange.remove(rankPairsPart);
                    lastChangedPart = rankPairsPart;
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
                        final rankPairsPart = x > y
                            ? RankPair.suited(
                                high: ranksInStrongnessOrder[y],
                                kicker: ranksInStrongnessOrder[x],
                              )
                            : RankPair.ofsuit(
                                high: ranksInStrongnessOrder[x],
                                kicker: ranksInStrongnessOrder[y],
                              );

                        return Expanded(
                          child: RankPairSelectGridItem(
                            rankPairsPart: rankPairsPart,
                            isSelected: selectedRange.contains(rankPairsPart),
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

class RankPairSelectGridItem extends StatelessWidget {
  RankPairSelectGridItem({
    @required this.rankPairsPart,
    this.isSelected = false,
    Key key,
  })  : assert(rankPairsPart != null),
        super(key: key);

  final RankPair rankPairsPart;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final style = AquaTheme.of(context).rankPairGridStyle;

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
            "${rankChars[rankPairsPart.high]}${rankChars[rankPairsPart.kicker]}",
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
