import "dart:math" as math;
import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_appear_animation.dart";
import "package:aqua/src/common_widgets/aqua_button.dart";
import "package:aqua/src/common_widgets/aqua_icons.dart";
import "package:aqua/src/common_widgets/aqua_preferences.dart";
import "package:aqua/src/common_widgets/aqua_scaffold.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/digits_text.dart";
import "package:aqua/src/common_widgets/editable_community_cards.dart";
import "package:aqua/src/common_widgets/editable_player_hand_setting.dart";
import "package:aqua/src/common_widgets/simulation_session.dart";
import "package:aqua/src/constants/hand.dart";
import "package:aqua/src/models/player_hand_setting_preset.dart";
import "package:aqua/src/services/simulation_isolate_service.dart";
import "package:aqua/src/utilities/system_ui_overlay_style.dart";
import "package:flutter/widgets.dart";

class SimulationPage extends StatefulWidget {
  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  SimulationSessionData _simulationSession;

  ScrollController _scrollController;

  bool _needsBottomPaddingForOverscroll;

  int _openPlayerHandSettingIndex;

  bool _isCommunityCardPopupOpen;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _needsBottomPaddingForOverscroll = false;
    _isCommunityCardPopupOpen = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Analytics.of(context).logScreenChange(
        screenName: "Simulation Screen",
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_simulationSession == null) {
      _simulationSession = SimulationSession.of(context);
    }

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
      actions: [
        AquaButton(
          variant: AquaButtonVariant.secondary,
          icon: AquaIcons.settings,
          onTap: () => Navigator.of(context).pushNamed("/preferences"),
        ),
      ],
      slivers: [
        AnimatedBuilder(
          animation: _simulationSession,
          builder: (context, _) => _simulationSession.hasPossibleMatchup
              ? SliverToBoxAdapter()
              : SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "No possible combination.\nReview player hands to recalculate.",
                      textAlign: TextAlign.left,
                      style: theme.textStyleSet.errorCaption,
                    ),
                  ),
                ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.loose(Size.fromWidth(320)),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCommunityCardPopupOpen = true;
                    });
                  },
                  child: AnimatedBuilder(
                    animation: _simulationSession,
                    builder: (context, _) => EditableCommunityCards(
                      initialCommunityCards: _simulationSession.communityCards,
                      unavailableCards:
                          _simulationSession.playerHandSettings.usedCards,
                      isPopupOpen: _isCommunityCardPopupOpen,
                      prepareForPopup: (overlayPosition) async {
                        await _scrollController.animateTo(
                          0.0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubic,
                        );
                      },
                      onTapChangeTarget: (index) {
                        Analytics.of(context).logEvent(
                          name: "Tap Community Cards' Change Target",
                          parameters: {
                            "Player Hand Setting Index": index,
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
                            "Number of Previous Community Cards":
                                _simulationSession.communityCards
                                    .where((card) => card != null)
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

                        _simulationSession.communityCards = communityCards;
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
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1f000000),
                          offset: Offset(0, 0),
                          blurRadius: 12,
                        ),
                        BoxShadow(
                          color: Color(0x0f000000),
                          offset: Offset(0, 12),
                          blurRadius: 24,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AnimatedBuilder(
                      animation: _simulationSession,
                      builder: (context, child) => AquaAppearAnimation(
                        isVisible:
                            _simulationSession.playerHandSettings.length < 10,
                        child: child,
                      ),
                      child: AquaButton(
                        variant: AquaButtonVariant.primary,
                        label: "Add",
                        icon: AquaIcons.plus,
                        onTap: () {
                          Analytics.of(context).logEvent(
                            name: "Tap the Add Player Hand Setting Button",
                            parameters: {
                              "Number of Previous Player Hand Settings":
                                  _simulationSession.playerHandSettings.length,
                              "Number of New Player Hand Settings":
                                  _simulationSession.playerHandSettings.length +
                                      1,
                            },
                          );

                          final nextIndex =
                              _simulationSession.playerHandSettings.length;

                          _simulationSession.playerHandSettings
                              .add(PlayerHandSetting.emptyHoleCards());

                          setState(() {
                            _openPlayerHandSettingIndex = nextIndex;
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
          animation: _simulationSession,
          builder: (context, _) =>
              _simulationSession.playerHandSettings.length < 2
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
                  : _simulationSession.playerHandSettings.hasIncomplete
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
          animation: _simulationSession,
          builder: (context, _) => SliverToBoxAdapter(
            child: Column(
              children: List.generate(
                  _simulationSession.playerHandSettings.length, (index) {
                final playerHandSetting =
                    _simulationSession.playerHandSettings[index];

                return _PlayerListItem(
                  indicator: GestureDetector(
                    key: ObjectKey(playerHandSetting),
                    onTap: () {
                      Analytics.of(context).logEvent(
                        name: "Tap a Player Hand Setting",
                        parameters: {
                          "Player Hand Setting Index": index,
                          "Number of Player Hand Settings":
                              _simulationSession.playerHandSettings.length,
                          "Player Hand Setting Type":
                              playerHandSetting.type.toString(),
                        },
                      );

                      setState(() {
                        _openPlayerHandSettingIndex = index;
                      });
                    },
                    child: EditablePlayerHandSetting(
                      initialInputMode:
                          PlayerHandSettingInputMode.fromPlayerHandSettingType(
                              playerHandSetting.type),
                      initialCardPair: playerHandSetting.firstHoleCardPair,
                      initialHandRange: playerHandSetting.handRange,
                      unavailableCards: {
                        ..._simulationSession.communityCards,
                        ..._simulationSession.playerHandSettings.usedCards
                            .where(
                          (card) =>
                              card != playerHandSetting.firstHoleCardPair[0] &&
                              card != playerHandSetting.firstHoleCardPair[1],
                        ),
                      },
                      isPopupOpen: index == _openPlayerHandSettingIndex,
                      prepareForPopup: (overlayPosition) async {
                        final nextScrollOffset = math.max(
                          _scrollController.offset +
                              overlayPosition.top -
                              MediaQuery.of(context).size.height +
                              overlayPosition.height +
                              MediaQuery.of(context).padding.bottom,
                          0.0,
                        );

                        if (nextScrollOffset > _scrollController.offset) {
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
                            "For": "Player Hand Setting",
                          },
                        );
                      },
                      onChangeStartHandRangeGrid: (part, isToMark) {
                        Analytics.of(context).logEvent(
                          name: "Change Start a Hand Range Slider",
                          parameters: {
                            "Player Hand Setting Index": index,
                            "Hand Range Part": part.toString(),
                            "to Mark": isToMark,
                          },
                        );
                      },
                      onChangeEndHandRangeGrid: (part, wasToMark) {
                        Analytics.of(context).logEvent(
                          name: "Change End a Hand Range Slider",
                          parameters: {
                            "Player Hand Setting Index": index,
                            "Hand Range Part": part.toString(),
                            "to Mark": wasToMark,
                          },
                        );
                      },
                      onChangeStartHandRangeSlider: (value) {
                        Analytics.of(context).logEvent(
                          name: "Change Start a Hand Range Slider",
                          parameters: {
                            "Player Hand Setting Index": index,
                            "Value": value,
                          },
                        );
                      },
                      onChangeEndHandRangeSlider: (value) {
                        Analytics.of(context).logEvent(
                          name: "Change End a Hand Range Slider",
                          parameters: {
                            "Player Hand Setting Index": index,
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
                                .pushNamed("/preset_select"))
                            as PlayerHandSettingPreset;

                        if (preset != null) {
                          final playerHandSetting =
                              preset.toPlayerHandSetting();

                          _simulationSession.playerHandSettings[index] =
                              playerHandSetting;
                        }
                      },
                      onTapDelete: () {
                        Analytics.of(context).logEvent(
                          name:
                              "Tap the Delete button in Player Hand Setting Editor Popup",
                          parameters: {
                            "Player Hand Setting Index": index,
                            "Number of Previous PlayerHand Settings":
                                _simulationSession.playerHandSettings.length,
                            "Number of New PlayerHand Settings":
                                _simulationSession.playerHandSettings.length -
                                    1,
                          },
                        );

                        _simulationSession.playerHandSettings.removeAt(index);

                        setState(() {
                          _openPlayerHandSettingIndex = null;
                        });
                      },
                      onRequestClose: () {
                        setState(() {
                          _openPlayerHandSettingIndex = null;
                        });
                      },
                      onOpenPopup: () {
                        setState(() {
                          _needsBottomPaddingForOverscroll = true;
                        });
                      },
                      onClosedPopup: (inputMode, cardPair, handRange) {
                        _simulationSession.playerHandSettings[index]
                            .firstHoleCardPair = cardPair;
                        _simulationSession.playerHandSettings[index].handRange =
                            handRange;
                        _simulationSession.playerHandSettings[index].type =
                            inputMode.toPlayerHandSettingType();

                        setState(() {
                          _needsBottomPaddingForOverscroll = false;
                        });
                      },
                    ),
                  ),
                  playerHandSetting: playerHandSetting,
                  result: _simulationSession.results.length > index
                      ? _simulationSession.results[index]
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
    Key key,
    @required this.playerHandSetting,
    this.result,
    @required this.indicator,
  })  : assert(playerHandSetting != null),
        assert(indicator != null),
        super(key: key);

  final PlayerHandSetting playerHandSetting;

  final PlayerSimulationOverallResult result;

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
              child: result != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedBuilder(
                          animation: preferences,
                          builder: (context, child) =>
                              preferences.prefersWinRate
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        DigitsText(
                                          result.winRate + result.tieRate,
                                          suffix: "% win",
                                        ),
                                        DigitsText(
                                          result.tieRate,
                                          textStyle: theme.textStyleSet.caption,
                                          useLargeWholeNumberPart: false,
                                          fractionDigits: 0,
                                          showAlmostEqualPrefix: true,
                                          suffix: "% tie",
                                        ),
                                      ],
                                    )
                                  : DigitsText(
                                      result.equity,
                                      suffix: "% equity",
                                    ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          child: Text(
                            result.winsByHandType.values.any((win) => win > 0)
                                ? "wins pot by ${(result.winsByHandType.entries.where((entry) => entry.value > 0).toList()..sort((a, b) => b.value - a.value)).take(3).map((entry) => handTypeStrings[entry.key]).join(", ")}"
                                : "",
                            style: theme.textStyleSet.caption,
                            maxLines: 2,
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
                            suffix: preferences.prefersWinRate
                                ? "% win"
                                : "% equity",
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
