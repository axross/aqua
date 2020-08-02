import "dart:io";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class AquaSlider extends StatefulWidget {
  AquaSlider({
    Key key,
    this.divisions,
    this.value,
    this.label,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  });

  final int divisions;

  final double value;

  final String label;

  final void Function(double value) onChanged;

  final void Function(double value) onChangeStart;

  final void Function(double value) onChangeEnd;

  @override
  State<AquaSlider> createState() => _AquaSliderState();
}

class _AquaSliderState extends State<AquaSlider> {
  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final style = theme.sliderStyle;

    return SliderTheme(
      data: SliderThemeData(
        thumbColor: style.thumbColor,
        activeTrackColor: style.activeTrackColor,
        inactiveTrackColor: style.inactiveTrackColor,
        valueIndicatorColor: style.valueIndicatorColor,
        valueIndicatorTextStyle: style.valueIndicatorTextStyle,
      ),
      child: Material(
        color: Color(0x00000000),
        child: Slider(
          divisions: widget.divisions,
          value: widget.value,
          label: widget.label,
          onChanged: (value) {
            if (Platform.isIOS) {
              HapticFeedback.selectionClick();
            }

            if (widget.onChanged != null) {
              widget.onChanged(value);
            }
          },
          onChangeStart: (value) {
            HapticFeedback.lightImpact();

            if (widget.onChangeStart != null) {
              widget.onChangeStart(value);
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd(value);
            }
          },
        ),
      ),
    );
  }
}
