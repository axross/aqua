import "package:aqua/app/preset_select_route.dart";
import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_appear_animation.dart";
import "package:aqua/src/common_widgets/aqua_button.dart";
import "package:aqua/src/common_widgets/aqua_icons.dart";
import "package:aqua/src/common_widgets/aqua_preferences.dart";
import "package:aqua/src/common_widgets/aqua_scaffold.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/digits_text.dart";
import "package:aqua/src/common_widgets/editable_community_cards.dart";
import "package:aqua/src/common_widgets/editable_hand_range.dart";
import "package:aqua/src/models/hand_range_preset.dart";
import "package:aqua/src/utilities/system_ui_overlay_style.dart";
import "package:aqua/src/view_models/hand_range_draft.dart";
import "package:aqua/src/view_models/simulation_session.dart";
import "package:flutter/widgets.dart";
import "package:poker/poker.dart";

class SimulationTabPage extends StatefulWidget {
  SimulationTabPage({
    required this.calculationSession,
    Key? key,
  }) : super(key: key);

  final CalculationSession calculationSession;

  @override
  _SimulationTabPageState createState() => _SimulationTabPageState();
}

class _SimulationTabPageState extends State<SimulationTabPage> {
  late ScrollController _scrollController;

  late bool _needsBottomPaddingForOverscroll;

  int? _openHandRangeIndex;

  late bool _isCommunityCardPopupOpen;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _needsBottomPaddingForOverscroll = false;
    _isCommunityCardPopupOpen = false;

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Analytics.of(context).logScreenChange(
        screenName: "Simulation Screen",
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final theme = AquaTheme.of(context);

    setSystemUIOverlayStyle(
      topColor: theme.scaffoldStyle.backgroundColor,
      bottomColor: theme.scaffoldStyle.backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);

    return AquaScadffold(
      scrollController: _scrollController,
      title: "Calculation",
      slivers: [
        AnimatedBuilder(
          animation: widget.calculationSession,
          // builder: (context, _) => widget.calculationSession.hasPossibleMatchup
          builder: (context, _) => SliverToBoxAdapter(),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.loose(Size.fromWidth(320)),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _isCommunityCardPopupOpen = true;
                    });
                  },
                  child: AnimatedBuilder(
                    animation: widget.calculationSession,
                    builder: (context, _) => EditableCommunityCards(
                      initialCommunityCards:
                          widget.calculationSession.communityCards,
                      unavailableCards:
                          widget.calculationSession.players.usedCards,
                      isPopupOpen: _isCommunityCardPopupOpen,
                      prepareForPopup: (overlayPosition) async {
                        final mediaQuery = MediaQuery.of(context);
                        final topOverflow =
                            0 - (overlayPosition.top - mediaQuery.padding.top);
                        final bottomOverflow = overlayPosition.bottom +
                            mediaQuery.padding.bottom -
                            mediaQuery.size.height;

                        double nextScrollOffset = _scrollController.offset;

                        if (topOverflow > 0) {
                          nextScrollOffset =
                              _scrollController.offset - topOverflow;
                        }

                        if (bottomOverflow > 0) {
                          nextScrollOffset =
                              _scrollController.offset + bottomOverflow;
                        }

                        if (nextScrollOffset != _scrollController.offset) {
                          await _scrollController.animateTo(
                            nextScrollOffset,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOutCubic,
                          );
                        }
                      },
                      onTapChangeTarget: (index) {
                        Analytics.of(context).logEvent(
                          name: "Tap Community Cards' Change Target",
                          parameters: {
                            "Hand Range Index": index,
                          },
                        );
                      },
                      onTapCardPicker: (card) {
                        Analytics.of(context).logEvent(
                          name: "Tap a Key of Card Keyboard",
                          parameters: {
                            "Card": card.toString(),
                            "For": "Communty Cards",
                          },
                        );
                      },
                      onTapClear: () {
                        Analytics.of(context).logEvent(
                          name: "Tap Clear Community Cards Button",
                          parameters: {
                            "Number of Previous Community Cards": widget
                                .calculationSession.communityCards
                                .toSet()
                                .length,
                          },
                        );
                      },
                      onOpenPopup: () {
                        Analytics.of(context).logEvent(
                          name: "Open Community Card Editor Popup",
                        );
                      },
                      onClosedPopup: (communityCards) {
                        Analytics.of(context).logEvent(
                          name: "Close Community Card Editor Popup",
                        );

                        widget.calculationSession.communityCards =
                            communityCards;
                      },
                      onRequestClose: () {
                        setState(() {
                          _isCommunityCardPopupOpen = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Player Hands",
                    textAlign: TextAlign.center,
                    style: theme.textStyleSet.headline,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      boxShadow: theme.elevationBoxShadows,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AnimatedBuilder(
                      animation: widget.calculationSession,
                      builder: (context, child) => AquaAppearAnimation(
                        isVisible:
                            widget.calculationSession.players.length < 10,
                        child: child!,
                      ),
                      child: AquaButton(
                        variant: AquaButtonVariant.primary,
                        label: "Add",
                        icon: AquaIcons.plus,
                        onTap: () {
                          Analytics.of(context).logEvent(
                            name: "Tap the Add Hand Range Button",
                            parameters: {
                              "Number of Previous Hand Ranges":
                                  widget.calculationSession.players.length,
                              "Number of New Hand Ranges":
                                  widget.calculationSession.players.length + 1,
                            },
                          );

                          final nextIndex =
                              widget.calculationSession.players.length;

                          widget.calculationSession.players
                              .add(HandRangeDraft.emptyCardPair());

                          setState(() {
                            _openHandRangeIndex = nextIndex;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: widget.calculationSession,
          builder: (context, _) => widget.calculationSession.players.length < 2
              ? SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Needs at least 2 players to calculate.",
                      textAlign: TextAlign.left,
                      style: theme.textStyleSet.caption,
                    ),
                  ),
                )
              : widget.calculationSession.players.hasIncomplete
                  ? SliverPadding(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          "Some player hand is incomplete. Fill or delete to calculate.",
                          textAlign: TextAlign.left,
                          style: theme.textStyleSet.caption,
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(),
        ),
        AnimatedBuilder(
          animation: widget.calculationSession,
          builder: (context, _) => SliverToBoxAdapter(
            child: Column(
              children: List.generate(widget.calculationSession.players.length,
                  (index) {
                final handRange = widget.calculationSession.players[index];

                return _PlayerListItem(
                  indicator: GestureDetector(
                    key: ObjectKey(handRange),
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Analytics.of(context).logEvent(
                        name: "Tap a Hand Range",
                        parameters: {
                          "Hand Range Index": index,
                          "Number of Hand Ranges":
                              widget.calculationSession.players.length,
                          "Hand Range Type": handRange.type.toString(),
                        },
                      );

                      setState(() {
                        _openHandRangeIndex = index;
                      });
                    },
                    child: EditableHandRange(
                      initialInputType: handRange.type,
                      initialCardPair: handRange.firstCardPair,
                      initialRankPairs: handRange.rankPairs,
                      unavailableCards: widget.calculationSession.communityCards
                          .union(CardSet(
                              widget.calculationSession.players.usedCards.where(
                        (card) =>
                            card != handRange.firstCardPair[0] &&
                            card != handRange.firstCardPair[1],
                      ))),
                      isPopupOpen: index == _openHandRangeIndex,
                      prepareForPopup: (overlayPosition) async {
                        final mediaQuery = MediaQuery.of(context);
                        final topOverflow =
                            0 - (overlayPosition.top - mediaQuery.padding.top);
                        final bottomOverflow = overlayPosition.bottom +
                            mediaQuery.padding.bottom -
                            mediaQuery.size.height;

                        double nextScrollOffset = _scrollController.offset;

                        if (topOverflow > 0) {
                          nextScrollOffset =
                              _scrollController.offset - topOverflow;
                        }

                        if (bottomOverflow > 0) {
                          nextScrollOffset =
                              _scrollController.offset + bottomOverflow;
                        }

                        if (nextScrollOffset != _scrollController.offset) {
                          await _scrollController.animateTo(
                            nextScrollOffset,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOutCubic,
                          );
                        }
                      },
                      onTapCardPicker: (card) {
                        Analytics.of(context).logEvent(
                          name: "Tap a Key of Card Keyboard",
                          parameters: {
                            "Card": card.toString(),
                            "For": "Hand Range",
                          },
                        );
                      },
                      onChangeStartRankPairGrid: (part, isToMark) {
                        Analytics.of(context).logEvent(
                          name: "Change Start a Rank Pair Grid Slider",
                          parameters: {
                            "Hand Range Index": index,
                            "Rank Pair": part.toString(),
                            "to Mark": isToMark,
                          },
                        );
                      },
                      onChangeEndRankPairGrid: (part, wasToMark) {
                        Analytics.of(context).logEvent(
                          name: "Change End a Rank Pair Grid Slider",
                          parameters: {
                            "Hand Range Index": index,
                            "RankPair": part.toString(),
                            "to Mark": wasToMark,
                          },
                        );
                      },
                      onChangeStartRankPairGridSlider: (value) {
                        Analytics.of(context).logEvent(
                          name: "Change Start a Rank Pair Grid Slider",
                          parameters: {
                            "Hand Range Index": index,
                            "Value": value,
                          },
                        );
                      },
                      onChangeEndRankPairGridSlider: (value) {
                        Analytics.of(context).logEvent(
                          name: "Change End a Rank Pair Grid Slider",
                          parameters: {
                            "Hand Range Index": index,
                            "Value": value,
                          },
                        );
                      },
                      onTapPresets: () async {
                        Analytics.of(context).logEvent(
                          name: "Tap Presets Button",
                        );

                        await Future.delayed(Duration(milliseconds: 300));

                        final preset = (await Navigator.of(context)
                            .push(PresetSelectRoute())) as HandRangePreset?;

                        if (preset != null) {
                          final handRange =
                              HandRangeDraft.fromHandRange(preset.handRange);

                          widget.calculationSession.players[index] = handRange;
                        }
                      },
                      onTapDelete: () {
                        Analytics.of(context).logEvent(
                          name:
                              "Tap the Delete button in Hand Range Editor Popup",
                          parameters: {
                            "Hand Range Index": index,
                            "Number of Previous Hand Ranges":
                                widget.calculationSession.players.length,
                            "Number of New Hand Ranges":
                                widget.calculationSession.players.length - 1,
                          },
                        );

                        widget.calculationSession.players.removeAt(index);

                        setState(() {
                          _openHandRangeIndex = null;
                        });
                      },
                      onRequestClose: () {
                        setState(() {
                          _openHandRangeIndex = null;
                        });
                      },
                      onOpenPopup: () {
                        setState(() {
                          _needsBottomPaddingForOverscroll = true;
                        });
                      },
                      onClosedPopup: (inputType, cardPair, rankPairs) {
                        widget.calculationSession.players[index].firstCardPair =
                            cardPair;
                        widget.calculationSession.players[index].rankPairs =
                            rankPairs;
                        widget.calculationSession.players[index].type =
                            inputType;

                        setState(() {
                          _needsBottomPaddingForOverscroll = false;
                        });
                      },
                    ),
                  ),
                  result: widget.calculationSession.result,
                  playerResult:
                      widget.calculationSession.result.players.length > index
                          ? widget.calculationSession.result.players[index]
                          : null,
                );
              }),
            ),
          ),
        ),
        if (_needsBottomPaddingForOverscroll)
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height,
            ),
          ),
      ],
    );
  }
}

class _PlayerListItem extends StatelessWidget {
  _PlayerListItem({
    this.result,
    required this.playerResult,
    required this.indicator,
    Key? key,
  }) : super(key: key);

  final EvaluationResult? result;

  final EvaluationResultPlayer? playerResult;

  final Widget indicator;

  @override
  Widget build(BuildContext context) {
    final preferences = AquaPreferences.of(context);
    final theme = AquaTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: indicator,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: result != null && playerResult != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedBuilder(
                          animation: preferences,
                          builder: (context, child) => DigitsText(
                            result!.games > 0
                                ? playerResult!.equity / result!.games
                                : 0,
                            suffix: "% equity",
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedBuilder(
                          animation: preferences,
                          builder: (context, child) => DigitsPlaceholderText(
                            suffix: "% equity",
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          child: Text(
                            "",
                            style: theme.textStyleSet.caption,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
