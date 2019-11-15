import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/common_widgets/aqua_theme.dart';
import 'package:aqua/common_widgets/tiny_stadium_button.dart';
import 'package:aqua/models/card.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TopButtons extends StatelessWidget {
  TopButtons({@required this.onClearButtonTapped, Key key})
      : assert(onClearButtonTapped != null),
        super(key: key);

  final void Function() onClearButtonTapped;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final simulationSession = SimulationSessionProvider.of(context);

    return ValueListenableBuilder<List<Card>>(
      valueListenable: simulationSession.board,
      builder: (context, board, _) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: TinyStadiumButton(
              label: "Clear",
              foregroundColor: board.any((card) => card != null)
                  ? theme.whiteForegroundColor
                  : theme.dimForegroundColor,
              backgroundColor: board.any((card) => card != null)
                  ? theme.heartForegroundColor
                  : theme.dimBackgroundColor,
              onTap: () {
                HapticFeedback.lightImpact();

                simulationSession.board.value = [null, null, null, null, null];

                Analytics.of(context).logEvent(
                  name: "clear_board_cards",
                );

                onClearButtonTapped();
              },
            ),
          ),
        ],
      ),
    );
  }
}
