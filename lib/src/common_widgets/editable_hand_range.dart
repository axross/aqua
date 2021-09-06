import "dart:ui" show ImageFilter;
import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_button.dart";
import "package:aqua/src/common_widgets/aqua_icons.dart";
import "package:aqua/src/common_widgets/aqua_popup_transition.dart";
import "package:aqua/src/common_widgets/aqua_slider.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/card_picker.dart";
import "package:aqua/src/common_widgets/rank_pair_select_grid.dart";
import "package:aqua/src/common_widgets/playing_card.dart";
import "package:aqua/src/common_widgets/readonly_rank_pair_grid.dart";
import "package:aqua/src/constants/hand_range.dart";
import "package:aqua/src/view_models/card_pair_draft.dart";
import "package:aqua/src/view_models/hand_range_draft.dart";
import "package:flutter/widgets.dart";
import "package:poker/poker.dart";

class EditableHandRange extends StatefulWidget {
  EditableHandRange({
    required this.initialInputType,
    this.initialCardPair,
    this.initialRankPairs,
    this.unavailableCards = CardSet.empty,
    this.isPopupOpen = false,
    this.prepareForPopup,
    this.onTapCardPicker,
    this.onChangeStartRankPairGridSlider,
    this.onChangeEndRankPairGridSlider,
    this.onChangeStartRankPairGrid,
    this.onChangeEndRankPairGrid,
    this.onTapPresets,
    this.onTapDelete,
    this.onRequestClose,
    this.onOpenPopup,
    this.onClosedPopup,
    Key? key,
  }) : super(key: key);

  final HandRangeDraftInputType? initialInputType;

  final CardPairDraft? initialCardPair;

  final Set<RankPair>? initialRankPairs;

  final CardSet unavailableCards;

  final bool isPopupOpen;

  final Future<void> Function(Rect overlayRect)? prepareForPopup;

  final void Function(Card card)? onTapCardPicker;

  final void Function(double value)? onChangeStartRankPairGridSlider;

  final void Function(double value)? onChangeEndRankPairGridSlider;

  final void Function(RankPair part, bool isToMark)? onChangeStartRankPairGrid;

  final void Function(RankPair part, bool wasToMark)? onChangeEndRankPairGrid;

  final VoidCallback? onTapPresets;

  final VoidCallback? onTapDelete;

  final VoidCallback? onRequestClose;

  final VoidCallback? onOpenPopup;

  final void Function(
    HandRangeDraftInputType inputType,
    CardPairDraft cardPair,
    Set<RankPair> handRange,
  )? onClosedPopup;

  @override
  State<EditableHandRange> createState() => _EditableHandRangeState();
}

class _EditableHandRangeState extends State<EditableHandRange>
    with TickerProviderStateMixin {
  final _key = GlobalKey();

  late _EditableHandRangeStateBus _stateBus;

  late AnimationController _animationController;

  late AnimationController _popupElementsAnimationController;

  late Animation<double> _curvedAnimation;

  late Animation<double> _popupElementsCurvedAnimation;

  OverlayEntry? _touchAbsorverEntry;

  OverlayEntry? _curtainOverlayEntry;

  List<OverlayEntry> _typeSpecificOverlayEntries = [];

  @override
  void initState() {
    super.initState();

    _stateBus = _EditableHandRangeStateBus(
      initialInputType:
          widget.initialInputType ?? HandRangeDraftInputType.cardPair,
      initialCardPair: widget.initialCardPair ?? CardPairDraft.empty(),
      initialRankPairs: widget.initialRankPairs ?? {},
    );

    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _popupElementsAnimationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _popupElementsCurvedAnimation = CurvedAnimation(
      parent: _popupElementsAnimationController,
      curve: Curves.easeInOutCubic,
    );

    if (widget.isPopupOpen) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _openPopup();
      });
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPopupOpen != oldWidget.isPopupOpen) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (widget.isPopupOpen) {
          _openPopup();
        } else {
          _closePopup().then((_) {
            _stateBus.isButtonsDisabled = false;
          });
        }
      });
    }
  }

  void _onTapInputModeToggle() async {
    await _popupElementsAnimationController.reverse();

    _removeTypeSpecificOverlayEntries();

    // TODO: refactor this if you have better idea
    // HACK: we need to wait for build triggered by hand range type change
    // because it's impossible to calculate the render box until it rebuilds
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await _prepareOpenPopup();

      _addTypeSpecificOverlayEntries();

      await _popupElementsAnimationController.forward();
    });

    switch (_stateBus.inputType) {
      case HandRangeDraftInputType.cardPair:
        _stateBus.inputType = HandRangeDraftInputType.rankPairs;
        break;
      case HandRangeDraftInputType.rankPairs:
        _stateBus.inputType = HandRangeDraftInputType.cardPair;
        break;
      default:
        throw UnimplementedError();
    }
  }

  Future<void> _openPopup() async {
    if (_touchAbsorverEntry != null) return;

    if (widget.onOpenPopup != null) {
      widget.onOpenPopup!();
    }

    final overlayState = Overlay.of(_key.currentContext!, rootOverlay: true)!;

    _touchAbsorverEntry = OverlayEntry(
      builder: (context) => _buildTouchAbsorber(context),
    );
    overlayState.insert(_touchAbsorverEntry!);

    await _prepareOpenPopup();

    Analytics.of(context).logScreenChange(
      screenName: "Hand Range Editor Popup",
    );

    _curtainOverlayEntry = OverlayEntry(
      builder: (context) => _buildCurtain(
        context,
        onRequestClose: widget.onRequestClose!,
      ),
    );
    overlayState.insert(_curtainOverlayEntry!);

    _addTypeSpecificOverlayEntries();

    await Future.wait([
      _animationController.forward(),
      _popupElementsAnimationController.forward(),
    ]);
  }

  void _addTypeSpecificOverlayEntries() {
    final actions = OverlayEntry(
      builder: (context) => _buildActions(context),
    );

    switch (_stateBus.inputType) {
      case HandRangeDraftInputType.cardPair:
        _typeSpecificOverlayEntries = [
          actions,
          OverlayEntry(builder: (context) => _buildHoleCardSelector(context)),
          OverlayEntry(builder: (context) => _buildCardPicker(context)),
        ];
        break;
      case HandRangeDraftInputType.rankPairs:
        _typeSpecificOverlayEntries = [
          actions,
          OverlayEntry(
            builder: (context) => _buildRankPairIndicatorGrid(context),
          ),
          OverlayEntry(builder: (context) => _buildRankPairEditor(context)),
        ];
        break;
      default:
        throw UnimplementedError();
    }

    Overlay.of(_key.currentContext!, rootOverlay: true)!
        .insertAll(_typeSpecificOverlayEntries);
  }

  Future<void> _closePopup() async {
    if (_touchAbsorverEntry == null) return;

    _touchAbsorverEntry!.remove();
    _touchAbsorverEntry = null;

    await Future.wait([
      _animationController.reverse(),
      _popupElementsAnimationController.reverse(),
    ]);

    _curtainOverlayEntry!.remove();
    _curtainOverlayEntry = null;

    _removeTypeSpecificOverlayEntries();

    if (widget.onClosedPopup != null) {
      widget.onClosedPopup!(
        _stateBus.inputType,
        _stateBus.cardPair,
        _stateBus.rankPairs,
      );
    }
  }

  void _removeTypeSpecificOverlayEntries() {
    for (final entry in _typeSpecificOverlayEntries) {
      entry.remove();
    }

    _typeSpecificOverlayEntries = [];
  }

  Future<void> _prepareOpenPopup() async {
    if (widget.prepareForPopup != null) {
      // calculate picker global offset before scroll/reposition
      // this global offset will change after prepareForPopup()
      Rect indicatorRect;
      Rect controlRect;

      switch (_stateBus.inputType) {
        case HandRangeDraftInputType.cardPair:
          indicatorRect = _getHoleCardSelectorRect();
          controlRect = _getCardPickerRect();
          break;
        case HandRangeDraftInputType.rankPairs:
          indicatorRect = _getRankPairIndicatorGridRect();
          controlRect = _getRankPairEditorRect();
          break;
        default:
          throw UnimplementedError();
      }

      await widget.prepareForPopup!(
        indicatorRect
            .expandToInclude(controlRect)
            .expandToInclude(_getActionsRect()),
      );
    }
  }

  Rect _getHoleCardSelectorRect() {
    final childRenderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final holeCardSelectorSize = childRenderBox.size +
        Offset(
          _holeCardSelectorPadding.horizontal,
          _holeCardSelectorPadding.vertical,
        );

    return childRenderBox
                .localToGlobal(holeCardSelectorSize.topLeft(Offset.zero)) -
            Offset(
              _holeCardSelectorPadding.left,
              _holeCardSelectorPadding.top,
            ) &
        holeCardSelectorSize;
  }

  Rect _getRankPairIndicatorGridRect() {
    final childRenderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final rankPairIndicatorGridSize = childRenderBox.size +
        Offset(
          _rankPairIndicatorGridPadding.horizontal,
          _rankPairIndicatorGridPadding.vertical,
        );

    return childRenderBox
                .localToGlobal(rankPairIndicatorGridSize.topLeft(Offset.zero)) -
            Offset(
              _rankPairIndicatorGridPadding.left,
              _rankPairIndicatorGridPadding.top,
            ) &
        rankPairIndicatorGridSize;
  }

  Rect _getCardPickerRect() =>
      Offset(0.0, _getHoleCardSelectorRect().bottom) & _getCardPickerSize();

  Size _getCardPickerSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    final playingCardAspectRatio = 2.25 / 3.5;
    final cardGap = 2.0;

    return Size(
      screenWidth,
      (screenWidth - _controlPadding.horizontal - cardGap * 12) /
              13 /
              playingCardAspectRatio *
              4 +
          cardGap * 3 +
          _controlPadding.vertical,
    );
  }

  Rect _getRankPairEditorRect() {
    final rankPairIndicatorRect = _getRankPairIndicatorGridRect();

    return Offset(0.0, rankPairIndicatorRect.bottom) & _getRankPairEditorSize();
  }

  Size _getRankPairEditorSize() => Size(MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.width + 16 + 60);

  Rect _getActionsRect() {
    final mediaQuery = MediaQuery.of(context);
    Rect indicatorRect;

    switch (_stateBus.inputType) {
      case HandRangeDraftInputType.cardPair:
        indicatorRect = _getHoleCardSelectorRect();
        break;
      case HandRangeDraftInputType.rankPairs:
        indicatorRect = _getRankPairIndicatorGridRect();
        break;
      default:
        throw UnimplementedError();
    }

    return Rect.fromLTRB(
      indicatorRect.right,
      indicatorRect.bottom -
          _actionsPadding.top -
          aquaButtonHeight * 3 -
          _actionsGap * 2,
      mediaQuery.size.width - mediaQuery.padding.right - _actionsPadding.right,
      indicatorRect.bottom - _actionsPadding.bottom,
    );
  }

  _buildTouchAbsorber(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: SizedBox.expand(),
      ),
    );
  }

  _buildCurtain(BuildContext context,
      {required void Function() onRequestClose}) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _curvedAnimation,
        builder: (context, child) => BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: Tween(
              begin: 0.0,
              end: 8.0,
            ).animate(_curvedAnimation).value,
            sigmaY: Tween(
              begin: 0.0,
              end: 8.0,
            ).animate(_curvedAnimation).value,
          ),
          child: DecoratedBoxTransition(
            // TODO:
            // make it themed
            decoration: DecorationTween(
              begin: BoxDecoration(color: Color(0x00000000)),
              end: BoxDecoration(color: Color(0x1f000000)),
            ).animate(_curvedAnimation),
            child: child!,
          ),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onRequestClose,
          child: SizedBox.expand(),
        ),
      ),
    );
  }

  _buildActions(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Positioned.fromRect(
      rect: _getActionsRect(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AquaPopupTransition(
                animation: _popupElementsCurvedAnimation,
                child: DecoratedBoxTransition(
                  decoration: DecorationTween(
                    begin:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    end: BoxDecoration(
                      boxShadow: theme.elevationBoxShadows,
                    ),
                  ).animate(_popupElementsCurvedAnimation),
                  child: AnimatedBuilder(
                    animation: _stateBus,
                    builder: (context, _) => AquaButton(
                      variant: AquaButtonVariant.danger,
                      label: "Delete",
                      icon: AquaIcons.trash,
                      onTap: _stateBus.isButtonsDisabled
                          ? null
                          : () async {
                              _stateBus.isButtonsDisabled = true;

                              await _closePopup();

                              if (widget.onTapDelete != null) {
                                widget.onTapDelete!();
                              }
                            },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              AquaPopupTransition(
                animation: _popupElementsCurvedAnimation,
                child: DecoratedBoxTransition(
                  decoration: DecorationTween(
                    begin:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    end: BoxDecoration(
                      boxShadow: theme.elevationBoxShadows,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ).animate(_popupElementsCurvedAnimation),
                  child: AnimatedBuilder(
                    animation: _stateBus,
                    builder: (context, _) => AquaButton(
                      variant: AquaButtonVariant.normal,
                      label: "Presets",
                      icon: AquaIcons.save,
                      onTap: _stateBus.isButtonsDisabled
                          ? null
                          : () async {
                              _stateBus.isButtonsDisabled = true;

                              if (widget.onRequestClose != null) {
                                widget.onRequestClose!();
                              }

                              if (widget.onTapPresets != null) {
                                widget.onTapPresets!();
                              }
                            },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              AquaPopupTransition(
                animation: _popupElementsCurvedAnimation,
                child: DecoratedBoxTransition(
                  decoration: DecorationTween(
                    begin:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    end: BoxDecoration(
                      boxShadow: theme.elevationBoxShadows,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ).animate(_popupElementsCurvedAnimation),
                  child: AnimatedBuilder(
                    animation: _stateBus,
                    builder: (context, _) {
                      switch (_stateBus.inputType) {
                        case HandRangeDraftInputType.cardPair:
                          return AquaButton(
                            variant: AquaButtonVariant.normal,
                            label: "By Grid",
                            icon: AquaIcons.grid,
                            onTap: _stateBus.isButtonsDisabled
                                ? null
                                : _onTapInputModeToggle,
                          );
                        case HandRangeDraftInputType.rankPairs:
                          return AquaButton(
                            variant: AquaButtonVariant.normal,
                            label: "By Cards",
                            icon: AquaIcons.cardPair,
                            onTap: _stateBus.isButtonsDisabled
                                ? null
                                : _onTapInputModeToggle,
                          );
                        default:
                          throw UnimplementedError();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildHoleCardSelector(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Positioned.fromRect(
      rect: _getHoleCardSelectorRect(),
      child: AnimatedBuilder(
        animation: _stateBus,
        builder: (context, _) => Padding(
          padding: _holeCardSelectorPadding - _holeCardBorderPadding,
          child: Row(
            children: [
              Expanded(
                child: DecoratedBoxTransition(
                  decoration: DecorationTween(
                    begin: BoxDecoration(
                      color: theme.cursorColor.withOpacity(0.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    end: BoxDecoration(
                      color: _stateBus.selectedCardIndex == 0
                          ? theme.cursorColor
                          : theme.cursorColor.withOpacity(0.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ).animate(_popupElementsCurvedAnimation),
                  child: GestureDetector(
                    onTap: () {
                      _stateBus.selectedCardIndex = 0;
                    },
                    child: Padding(
                      padding: _holeCardBorderPadding,
                      child: DecoratedBoxTransition(
                        decoration: DecorationTween(
                          begin: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          end: BoxDecoration(
                            shape: BoxShape.rectangle,
                            boxShadow: theme.elevationBoxShadows,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ).animate(_popupElementsCurvedAnimation),
                        child: _stateBus.cardPair[0] != null
                            ? PlayingCard(card: _stateBus.cardPair[0]!)
                            : PlayingCardBack(),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: DecoratedBoxTransition(
                  decoration: DecorationTween(
                    begin: BoxDecoration(
                      color: theme.cursorColor.withOpacity(0.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    end: BoxDecoration(
                      color: _stateBus.selectedCardIndex == 1
                          ? theme.cursorColor
                          : theme.cursorColor.withOpacity(0.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ).animate(_popupElementsCurvedAnimation),
                  child: GestureDetector(
                    onTap: () {
                      _stateBus.selectedCardIndex = 1;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: DecoratedBoxTransition(
                        decoration: DecorationTween(
                          begin: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          end: BoxDecoration(
                            shape: BoxShape.rectangle,
                            boxShadow: theme.elevationBoxShadows,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ).animate(_popupElementsCurvedAnimation),
                        child: _stateBus.cardPair[1] != null
                            ? PlayingCard(card: _stateBus.cardPair[1]!)
                            : PlayingCardBack(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildRankPairIndicatorGrid(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Positioned.fromRect(
      rect: _getRankPairIndicatorGridRect(),
      child: AnimatedBuilder(
        animation: _stateBus,
        builder: (context, _) => Padding(
          padding: _rankPairIndicatorGridPadding,
          child: Column(
            children: [
              DecoratedBoxTransition(
                decoration: DecorationTween(
                  begin: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  end: BoxDecoration(
                    shape: BoxShape.rectangle,
                    boxShadow: theme.elevationBoxShadows,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ).animate(_popupElementsCurvedAnimation),
                child: ReadonlyRankPairGrid(rankPairs: _stateBus.rankPairs),
              ),
              SizedBox(height: 8),
              AnimatedBuilder(
                animation: _popupElementsCurvedAnimation,
                builder: (context, child) => Text(
                  "${(_stateBus.rankPairs.fold<int>(0, (len, part) => len + part.toCardPairs().length) / 1326 * 100).floor()}% combs",
                  style: theme.textStyleSet.caption.copyWith(
                    color: ColorTween(
                      begin: theme.textStyleSet.caption.color,
                      end: theme.textStyleSet.body.color,
                    ).animate(_popupElementsCurvedAnimation).value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCardPicker(BuildContext context) {
    return Positioned.fromRect(
      rect: _getCardPickerRect(),
      child: AquaPopupTransition(
        animation: _popupElementsCurvedAnimation,
        child: Padding(
          padding: _controlPadding,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              boxShadow: AquaTheme.of(context).elevationBoxShadows,
              borderRadius: BorderRadius.circular(8),
            ),
            child: AnimatedBuilder(
              animation: _stateBus,
              builder: (context, _) => CardPicker(
                unavailableCards: widget.unavailableCards
                    .union(_stateBus.cardPair[0] != null
                        ? CardSet.single(_stateBus.cardPair[0]!)
                        : CardSet.empty)
                    .union(_stateBus.cardPair[1] != null
                        ? CardSet.single(_stateBus.cardPair[1]!)
                        : CardSet.empty),
                onCardTap: (card) {
                  if (widget.onTapCardPicker != null) {
                    widget.onTapCardPicker!(card);
                  }

                  _stateBus.setCardAtCurrentIndex(card);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildRankPairEditor(BuildContext context) {
    return Positioned.fromRect(
      rect: _getRankPairEditorRect(),
      child: AquaPopupTransition(
        animation: _popupElementsCurvedAnimation,
        child: Padding(
          padding: _controlPadding,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              boxShadow: AquaTheme.of(context).elevationBoxShadows,
              borderRadius: BorderRadius.circular(8),
            ),
            child: AnimatedBuilder(
              animation: _stateBus,
              builder: (context, _) => Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: RankPairSelectGrid(
                      value: _stateBus.rankPairs,
                      onChanged: (rankPairs) {
                        _stateBus.rankPairs = rankPairs;
                      },
                      onChangeStart: widget.onChangeStartRankPairGrid,
                      onChangeEnd: widget.onChangeEndRankPairGrid,
                    ),
                  ),
                  SizedBox(height: 16),
                  AquaSlider(
                    divisions: rankPairsInStrongnessOrder.length,
                    value: _stateBus.rankPairs.length /
                        rankPairsInStrongnessOrder.length,
                    label:
                        "${_stateBus.rankPairs.fold<int>(0, (len, part) => len + part.toCardPairs().length)} (${(_stateBus.rankPairs.fold<int>(0, (len, part) => len + part.toCardPairs().length) / 1326 * 100).floor()}%) combs",
                    onChanged: (value) {
                      final rankPairLengthTaken =
                          (value * rankPairsInStrongnessOrder.length).round();

                      _stateBus.rankPairs = rankPairsInStrongnessOrder
                          .take(rankPairLengthTaken)
                          .toSet();
                    },
                    onChangeStart: widget.onChangeStartRankPairGridSlider,
                    onChangeEnd: widget.onChangeEndRankPairGridSlider,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _stateBus,
      builder: (context, _) {
        Widget child;

        switch (_stateBus.inputType) {
          case HandRangeDraftInputType.cardPair:
            child = Row(
              children: [
                Expanded(
                  child: _stateBus.cardPair[0] != null
                      ? PlayingCard(card: _stateBus.cardPair[0]!)
                      : PlayingCardBack(),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _stateBus.cardPair[1] != null
                      ? PlayingCard(card: _stateBus.cardPair[1]!)
                      : PlayingCardBack(),
                ),
              ],
            );
            break;
          case HandRangeDraftInputType.rankPairs:
            child = Column(
              children: [
                ReadonlyRankPairGrid(rankPairs: _stateBus.rankPairs),
                SizedBox(height: 8),
                Text(
                  "${(_stateBus.rankPairs.fold<int>(0, (len, part) => len + part.toCardPairs().length) / 1326 * 100).floor()}% combs",
                  style: AquaTheme.of(context).textStyleSet.caption,
                ),
              ],
            );
            break;
          default:
            throw UnimplementedError();
        }

        return SizedBox(key: _key, child: child);
      },
    );
  }
}

class _EditableHandRangeStateBus extends ChangeNotifier {
  _EditableHandRangeStateBus({
    required HandRangeDraftInputType initialInputType,
    required CardPairDraft initialCardPair,
    required Set<RankPair> initialRankPairs,
  })  : _inputType = initialInputType,
        _cardPair = initialCardPair,
        _rankPairs = initialRankPairs,
        _selectedCardIndex = 0,
        _isButtonsDisabled = false;

  HandRangeDraftInputType _inputType;

  CardPairDraft _cardPair;

  Set<RankPair> _rankPairs;

  int _selectedCardIndex;

  bool _isButtonsDisabled;

  HandRangeDraftInputType get inputType => _inputType;

  set inputType(HandRangeDraftInputType inputType) {
    _inputType = inputType;

    if (_inputType != HandRangeDraftInputType.cardPair) {
      _cardPair = CardPairDraft.empty();
    }

    if (_inputType != HandRangeDraftInputType.rankPairs) {
      _rankPairs = {};
    }

    notifyListeners();
  }

  CardPairDraft get cardPair => _cardPair;

  Set<RankPair> get rankPairs => _rankPairs;

  set rankPairs(Set<RankPair> rankPairs) {
    _rankPairs = rankPairs;

    notifyListeners();
  }

  int get selectedCardIndex => _selectedCardIndex;

  set selectedCardIndex(int index) {
    if (index == 1 && _cardPair[0] == null) {
      _selectedCardIndex = 0;
    }

    _selectedCardIndex = index;

    notifyListeners();
  }

  bool get isButtonsDisabled => _isButtonsDisabled;

  set isButtonsDisabled(isButtonsDisabled) {
    _isButtonsDisabled = isButtonsDisabled;

    notifyListeners();
  }

  setCardAtCurrentIndex(Card card) {
    _cardPair = _selectedCardIndex == 0
        ? CardPairDraft(card, _cardPair[1])
        : CardPairDraft(_cardPair[0], card);
    _selectedCardIndex = _selectedCardIndex == 0 ? 1 : 0;

    notifyListeners();
  }
}

const _holeCardSelectorPadding = EdgeInsets.all(16.0);
const _rankPairIndicatorGridPadding =
    EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
const _controlPadding = EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 2.0);
const _holeCardBorderPadding = EdgeInsets.all(4.0);
const _actionsPadding = EdgeInsets.all(16.0);
const _actionsGap = 8.0;
