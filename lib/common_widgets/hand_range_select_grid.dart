import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/models/player_hand_setting.dart';
import 'package:aqua/models/rank.dart';
import "package:flutter/widgets.dart";

typedef OnRangeSelectorUpdate = void Function(Set<HandRangePart>);

class HandRangeSelectGrid extends StatefulWidget {
  HandRangeSelectGrid({@required this.onUpdate, this.initial, Key key})
      : assert(onUpdate != null),
        super(key: key);

  final OnRangeSelectorUpdate onUpdate;

  final Set<HandRangePart> initial;

  @override
  State<HandRangeSelectGrid> createState() => _HandRangeSelectGridState();
}

class _HandRangeSelectGridState extends State<HandRangeSelectGrid> {
  Set<HandRangePart> selectedRange;
  bool isToCheck;

  @override
  void initState() {
    super.initState();

    selectedRange = widget.initial == null ? {} : widget.initial;
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
                    high: Rank.valuesInStrongnessOrder[x],
                    kicker: Rank.valuesInStrongnessOrder[y],
                    isSuited: true)
                : HandRangePart(
                    high: Rank.valuesInStrongnessOrder[x],
                    kicker: Rank.valuesInStrongnessOrder[y],
                    isSuited: false);

            isToCheck = !selectedRange.contains(handRangePart);

            if (isToCheck) {
              setState(() {
                selectedRange.add(handRangePart);
              });
            } else {
              setState(() {
                selectedRange.remove(handRangePart);
              });
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
                    high: Rank.valuesInStrongnessOrder[x],
                    kicker: Rank.valuesInStrongnessOrder[y],
                    isSuited: true)
                : HandRangePart(
                    high: Rank.valuesInStrongnessOrder[x],
                    kicker: Rank.valuesInStrongnessOrder[y],
                    isSuited: false);

            if (isToCheck) {
              setState(() {
                selectedRange.add(handRangePart);
              });
            } else {
              setState(() {
                selectedRange.remove(handRangePart);
              });
            }
          },
          onPanEnd: (_) {
            widget.onUpdate(selectedRange);
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
                            high: Rank.valuesInStrongnessOrder[x],
                            kicker: Rank.valuesInStrongnessOrder[y],
                            isSuited: true,
                          )
                        : HandRangePart(
                            high: Rank.valuesInStrongnessOrder[x],
                            kicker: Rank.valuesInStrongnessOrder[y],
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
        ? theme.selectedRangeBackgroundColor
        : handRangePart.isPocket
            ? theme.pocketRangeBackgroundColor
            : theme.rangeBackgroundColor;
    final textColor = isSelected
        ? theme.selectedRangeForegroundColor
        : handRangePart.isPocket
            ? theme.pocketRangeForegroundColor
            : theme.rangeForegroundColor;

    return LayoutBuilder(
      builder: (context, constraints) => DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(
          child: Text(
            '${_rankTextData[handRangePart.high]}${_rankTextData[handRangePart.kicker]}',
            style: theme.rangeTextStyle.copyWith(
              color: textColor,
              fontSize: constraints.maxWidth / 2,
            ),
          ),
        ),
      ),
    );
  }
}

final _rankTextData = {
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
