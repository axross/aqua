import 'package:aqua/common_widgets/analytics.dart';
import 'package:aqua/models/TinyStadiumButton.dart';
import 'package:aqua/models/card.dart';
import 'package:aqua/view_models/simulation_session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TopButtons extends StatelessWidget {
  TopButtons({@required this.onClearButtonTapped, Key key})
      : assert(onClearButtonTapped != null),
        super(key: key);

  final void Function() onClearButtonTapped;

  @override
  Widget build(BuildContext context) {
    final simulationSession = Provider.of<SimulationSession>(context);

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
                  ? _clearButtonForegroundColor
                  : _clearButtonDisabledForegroundColor,
              backgroundColor: board.any((card) => card != null)
                  ? _clearButtonBackgroundColor
                  : _clearButtonDisabledBackgroundColor,
              onTap: () {
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

const _clearButtonForegroundColor = Color(0xffffffff);
const _clearButtonBackgroundColor = Color(0xffff6b6b);
const _clearButtonDisabledForegroundColor = Color(0xffc8d6e5);
const _clearButtonDisabledBackgroundColor = Color(0x3fc8d6e5);
