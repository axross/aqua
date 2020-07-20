import 'package:aqua/src/common_widgets/aqua_theme.dart';
import 'package:aqua/src/common_widgets/card_picker.dart';
import 'package:aqua/src/common_widgets/playing_card.dart';
import 'package:aqua/src/view_models/simulation_session.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:poker/poker.dart';
import './top_buttons.dart';

class BoardSettingPage extends StatefulWidget {
  @override
  _BoardSettingPageState createState() => _BoardSettingPageState();
}

class _BoardSettingPageState extends State<BoardSettingPage> {
  SimulationSession _simulationSession;

  int _selectedIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_simulationSession == null) {
      _simulationSession = SimulationSessionProvider.of(context);
    }

    if (_selectedIndex == null) {
      final firstNullIndex =
          _simulationSession.communityCards.indexWhere((card) => card == null);

      _selectedIndex = firstNullIndex == -1 ? 0 : firstNullIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16),
      child: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: _simulationSession,
          builder: (context, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TopButtons(
                canClear: _simulationSession.communityCards
                    .any((card) => card != null),
                onClearButtonTapped: _onClearButtonTapped,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: _selectedIndex == 0
                          ? theme.highlightBackgroundColor
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();

                        _onCardTapToReplace(0);
                      },
                      child: _simulationSession.communityCards[0] == null
                          ? PlayingCardBack()
                          : PlayingCard(
                              card: _simulationSession.communityCards[0],
                            ),
                    ),
                  ),
                  Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: _selectedIndex == 1
                          ? theme.highlightBackgroundColor
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();

                        _onCardTapToReplace(1);
                      },
                      child: _simulationSession.communityCards[1] == null
                          ? PlayingCardBack()
                          : PlayingCard(
                              card: _simulationSession.communityCards[1],
                            ),
                    ),
                  ),
                  Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: _selectedIndex == 2
                          ? theme.highlightBackgroundColor
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();

                        _onCardTapToReplace(2);
                      },
                      child: _simulationSession.communityCards[2] == null
                          ? PlayingCardBack()
                          : PlayingCard(
                              card: _simulationSession.communityCards[2],
                            ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: _selectedIndex == 3
                          ? theme.highlightBackgroundColor
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();

                        _onCardTapToReplace(3);
                      },
                      child: _simulationSession.communityCards[3] == null
                          ? PlayingCardBack()
                          : PlayingCard(
                              card: _simulationSession.communityCards[3],
                            ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color: _selectedIndex == 4
                          ? theme.highlightBackgroundColor
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();

                        _onCardTapToReplace(4);
                      },
                      child: _simulationSession.communityCards[4] == null
                          ? PlayingCardBack()
                          : PlayingCard(
                              card: _simulationSession.communityCards[4],
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CardPicker(
                  unavailableCards: _simulationSession.usedCards,
                  onCardTap: _onCardTapInPicker,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onClearButtonTapped() {
    setState(() {
      _selectedIndex = 0;
    });

    _simulationSession.clearCommunityCards();
  }

  void _onCardTapToReplace(int index) => setState(() {
        _selectedIndex = index;
      });

  void _onCardTapInPicker(Card card) {
    if (_selectedIndex == null) return;

    _simulationSession.setCommunityCardAt(_selectedIndex, card);

    setState(() {
      _selectedIndex = (_selectedIndex + 1) % 5;
    });
  }
}
