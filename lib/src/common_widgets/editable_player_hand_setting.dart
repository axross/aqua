import "dart:ui" show ImageFilter;
import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_button.dart";
import "package:aqua/src/common_widgets/aqua_icons.dart";
import "package:aqua/src/common_widgets/aqua_popup_transition.dart";
import "package:aqua/src/common_widgets/aqua_slider.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/card_picker.dart";
import "package:aqua/src/common_widgets/hand_range_select_grid.dart";
import "package:aqua/src/common_widgets/playing_card.dart";
import "package:aqua/src/common_widgets/readonly_range_grid.dart";
import "package:aqua/src/common_widgets/simulation_session.dart";
import "package:aqua/src/constants/hand_range.dart";
import "package:aqua/src/models/nullable_card_pair.dart";
import "package:flutter/widgets.dart";
import "package:poker/poker.dart";

class EditablePlayerHandSetting extends StatefulWidget {
  EditablePlayerHandSetting({
    this.initialInputMode = PlayerHandSettingInputMode.cardPair,
    this.initialCardPair = const NullableCardPair.empty(),
    this.initialHandRange = const {},
    this.unavailableCards = const {},
    this.isPopupOpen = false,
    this.prepareForPopup,
    this.onTapCardPicker,
    this.onChangeStartHandRangeSlider,
    this.onChangeEndHandRangeSlider,
    this.onChangeStartHandRangeGrid,
    this.onChangeEndHandRangeGrid,
    this.onTapPresets,
    this.onTapDelete,
    this.onRequestClose,
    this.onOpenPopup,
    this.onClosedPopup,
    Key key,
  }) : super(key: key);

  final PlayerHandSettingInputMode initialInputMode;

  final NullableCardPair initialCardPair;

  final Set<HandRangePart> initialHandRange;

  final Set<Card> unavailableCards;

  final bool isPopupOpen;

  final Future<void> Function(Rect overlayRect) prepareForPopup;

  final void Function(Card card) onTapCardPicker;

  final void Function(double value) onChangeStartHandRangeSlider;

  final void Function(double value) onChangeEndHandRangeSlider;

  final void Function(HandRangePart part, bool isToMark)
      onChangeStartHandRangeGrid;

  final void Function(HandRangePart part, bool wasToMark)
      onChangeEndHandRangeGrid;

  final VoidCallback onTapPresets;

  final VoidCallback onTapDelete;

  final VoidCallback onRequestClose;

  final VoidCallback onOpenPopup;

  final void Function(
    PlayerHandSettingInputMode inputMode,
    NullableCardPair cardPair,
    Set<HandRangePart> handRange,
  ) onClosedPopup;

  @override
  State<EditablePlayerHandSetting> createState() =>
      _EditablePlayerHandSettingState();
}

class _EditablePlayerHandSettingState extends State<EditablePlayerHandSetting>
    with TickerProviderStateMixin {
  final _key = GlobalKey();

  _EditablePlayerHandSettingStateBus _stateBus;

  AnimationController _animationController;

  AnimationController _popupElementsAnimationController;

  Animation _curvedAnimation;

  Animation _popupElementsCurvedAnimation;

  OverlayEntry _touchAbsorverEntry;

  OverlayEntry _curtainOverlayEntry;

  List<OverlayEntry> _typeSpecificOverlayEntries = [];

  @override
  void initState() {
    super.initState();

    _stateBus = _EditablePlayerHandSettingStateBus(
      initialInputMode: widget.initialInputMode,
      initialCardPair: widget.initialCardPair,
      initialHandRange: widget.initialHandRange,
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openPopup();
      });
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPopupOpen != oldWidget.isPopupOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
    // HACK: we need to wait for build triggered by player hand setting type change
    // because it's impossible to calculate the render box until it rebuilds
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _prepareOpenPopup();

      _addTypeSpecificOverlayEntries();

      await _popupElementsAnimationController.forward();
    });

    switch (_stateBus.inputMode) {
      case PlayerHandSettingInputMode.cardPair:
        _stateBus.inputMode = PlayerHandSettingInputMode.handRange;
        break;
      case PlayerHandSettingInputMode.handRange:
        _stateBus.inputMode = PlayerHandSettingInputMode.cardPair;
        break;
      default:
        throw UnimplementedError();
    }
  }

  Future<void> _openPopup() async {
    if (_touchAbsorverEntry != null) return;

    if (widget.onOpenPopup != null) {
      widget.onOpenPopup();
    }

    final overlayState = Overlay.of(_key.currentContext);

    _touchAbsorverEntry = OverlayEntry(
      builder: (context) => _buildTouchAbsorber(context),
    );
    overlayState.insert(_touchAbsorverEntry);

    await _prepareOpenPopup();

    Analytics.of(context).logScreenChange(
      screenName: "Player Hand Setting Editor Popup",
    );

    _curtainOverlayEntry = OverlayEntry(
      builder: (context) => _buildCurtain(
        context,
        onRequestClose: widget.onRequestClose,
      ),
    );
    overlayState.insert(_curtainOverlayEntry);

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

    switch (_stateBus.inputMode) {
      case PlayerHandSettingInputMode.cardPair:
        _typeSpecificOverlayEntries = [
          actions,
          OverlayEntry(builder: (context) => _buildHoleCardSelector(context)),
          OverlayEntry(builder: (context) => _buildCardPicker(context)),
        ];
        break;
      case PlayerHandSettingInputMode.handRange:
        _typeSpecificOverlayEntries = [
          actions,
          OverlayEntry(
            builder: (context) => _buildHandRangeIndicatorGrid(context),
          ),
          OverlayEntry(builder: (context) => _buildHandRangeEditor(context)),
        ];
        break;
      default:
        throw UnimplementedError();
    }

    Overlay.of(_key.currentContext).insertAll(_typeSpecificOverlayEntries);
  }

  Future<void> _closePopup() async {
    if (_touchAbsorverEntry == null) return;

    _touchAbsorverEntry.remove();
    _touchAbsorverEntry = null;

    await Future.wait([
      _animationController.reverse(),
      _popupElementsAnimationController.reverse(),
    ]);

    _curtainOverlayEntry.remove();
    _curtainOverlayEntry = null;

    _removeTypeSpecificOverlayEntries();

    if (widget.onClosedPopup != null) {
      widget.onClosedPopup(
        _stateBus.inputMode,
        _stateBus.cardPair,
        _stateBus.handRange,
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

      switch (_stateBus.inputMode) {
        case PlayerHandSettingInputMode.cardPair:
          indicatorRect = _getHoleCardSelectorRect();
          controlRect = _getCardPickerRect();
          break;
        case PlayerHandSettingInputMode.handRange:
          indicatorRect = _getHandRangeIndicatorGridRect();
          controlRect = _getHandRangeEditorRect();
          break;
        default:
          throw UnimplementedError();
      }

      await widget.prepareForPopup(
        indicatorRect
            .expandToInclude(controlRect)
            .expandToInclude(_getActionsRect()),
      );
    }
  }

  Rect _getHoleCardSelectorRect() {
    final RenderBox childRenderBox = _key.currentContext.findRenderObject();
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

  Rect _getHandRangeIndicatorGridRect() {
    final RenderBox childRenderBox = _key.currentContext.findRenderObject();
    final handRangeIndicatorGridSize = childRenderBox.size +
        Offset(
          _handRangeIndicatorGridPadding.horizontal,
          _handRangeIndicatorGridPadding.vertical,
        );

    return childRenderBox.localToGlobal(
                handRangeIndicatorGridSize.topLeft(Offset.zero)) -
            Offset(
              _handRangeIndicatorGridPadding.left,
              _handRangeIndicatorGridPadding.top,
            ) &
        handRangeIndicatorGridSize;
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

  Rect _getHandRangeEditorRect() {
    final handRangeIndicatorRect = _getHandRangeIndicatorGridRect();

    return Offset(0.0, handRangeIndicatorRect.bottom) &
        _getHandRangeEditorSize();
  }

  Size _getHandRangeEditorSize() => Size(MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.width + 16 + 60);

  Rect _getActionsRect() {
    final mediaQuery = MediaQuery.of(context);
    Rect indicatorRect;

    switch (_stateBus.inputMode) {
      case PlayerHandSettingInputMode.cardPair:
        indicatorRect = _getHoleCardSelectorRect();
        break;
      case PlayerHandSettingInputMode.handRange:
        indicatorRect = _getHandRangeIndicatorGridRect();
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

  _buildCurtain(BuildContext context, {@required Function onRequestClose}) {
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
              begin: BoxDecoration(color: Color(0x1f000000)),
              end: BoxDecoration(color: Color(0x1f000000)),
            ).animate(_curvedAnimation),
            child: child,
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
                                widget.onTapDelete();
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
                                widget.onRequestClose();
                              }

                              if (widget.onTapPresets != null) {
                                widget.onTapPresets();
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
                      switch (_stateBus.inputMode) {
                        case PlayerHandSettingInputMode.cardPair:
                          return AquaButton(
                            variant: AquaButtonVariant.normal,
                            label: "By Hand Range",
                            icon: AquaIcons.grid,
                            onTap: _stateBus.isButtonsDisabled
                                ? null
                                : _onTapInputModeToggle,
                          );
                        case PlayerHandSettingInputMode.handRange:
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
                            ? PlayingCard(card: _stateBus.cardPair[0])
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
                            ? PlayingCard(card: _stateBus.cardPair[1])
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

  _buildHandRangeIndicatorGrid(BuildContext context) {
    final theme = AquaTheme.of(context);

    return Positioned.fromRect(
      rect: _getHandRangeIndicatorGridRect(),
      child: AnimatedBuilder(
        animation: _stateBus,
        builder: (context, _) => Padding(
          padding: _handRangeIndicatorGridPadding,
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
                child: ReadonlyRangeGrid(handRange: _stateBus.handRange),
              ),
              SizedBox(height: 8),
              AnimatedBuilder(
                animation: _popupElementsCurvedAnimation,
                builder: (context, child) => Text(
                  "${(_stateBus.handRange.fold(0, (len, part) => len + part.cardPairCombinations.length) / 1326 * 100).floor()}% combs",
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
                unavailableCards: {
                  ...widget.unavailableCards,
                  _stateBus.cardPair[0],
                  _stateBus.cardPair[1],
                },
                onCardTap: (card) {
                  if (widget.onTapCardPicker != null) {
                    widget.onTapCardPicker(card);
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

  _buildHandRangeEditor(BuildContext context) {
    return Positioned.fromRect(
      rect: _getHandRangeEditorRect(),
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
                    child: HandRangeSelectGrid(
                      value: _stateBus.handRange,
                      onChanged: (handRange) {
                        _stateBus.handRange = handRange;
                      },
                      onChangeStart: widget.onChangeStartHandRangeGrid,
                      onChangeEnd: widget.onChangeEndHandRangeGrid,
                    ),
                  ),
                  SizedBox(height: 16),
                  AquaSlider(
                    divisions: handRangeComponentsInStrongnessOrder.length,
                    value: _stateBus.handRange.length /
                        handRangeComponentsInStrongnessOrder.length,
                    label:
                        "${_stateBus.handRange.fold(0, (len, part) => len + part.cardPairCombinations.length)} (${(_stateBus.handRange.fold(0, (len, part) => len + part.cardPairCombinations.length) / 1326 * 100).floor()}%) combs",
                    onChanged: (value) {
                      final handRangeLengthTaken =
                          (value * handRangeComponentsInStrongnessOrder.length)
                              .round();

                      _stateBus.handRange = handRangeComponentsInStrongnessOrder
                          .take(handRangeLengthTaken)
                          .toSet();
                    },
                    onChangeStart: widget.onChangeStartHandRangeSlider,
                    onChangeEnd: widget.onChangeEndHandRangeSlider,
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

        switch (_stateBus.inputMode) {
          case PlayerHandSettingInputMode.cardPair:
            child = Row(
              children: [
                Expanded(
                  child: _stateBus.cardPair[0] != null
                      ? PlayingCard(card: _stateBus.cardPair[0])
                      : PlayingCardBack(),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _stateBus.cardPair[1] != null
                      ? PlayingCard(card: _stateBus.cardPair[1])
                      : PlayingCardBack(),
                ),
              ],
            );
            break;
          case PlayerHandSettingInputMode.handRange:
            child = Column(
              children: [
                ReadonlyRangeGrid(handRange: _stateBus.handRange),
                SizedBox(height: 8),
                Text(
                  "${(_stateBus.handRange.fold(0, (len, part) => len + part.cardPairCombinations.length) / 1326 * 100).floor()}% combs",
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

class _EditablePlayerHandSettingStateBus extends ChangeNotifier {
  _EditablePlayerHandSettingStateBus({
    @required PlayerHandSettingInputMode initialInputMode,
    @required NullableCardPair initialCardPair,
    @required Set<HandRangePart> initialHandRange,
  })  : assert(initialInputMode != null),
        assert(initialCardPair != null),
        assert(initialHandRange != null),
        _inputMode = initialInputMode,
        _cardPair = initialCardPair,
        _handRange = initialHandRange,
        _selectedCardIndex = 0,
        _isButtonsDisabled = false;

  PlayerHandSettingInputMode _inputMode;

  NullableCardPair _cardPair;

  Set<HandRangePart> _handRange;

  int _selectedCardIndex;

  bool _isButtonsDisabled;

  PlayerHandSettingInputMode get inputMode => _inputMode;

  set inputMode(PlayerHandSettingInputMode inputMode) {
    _inputMode = inputMode;

    if (_inputMode != PlayerHandSettingInputMode.cardPair) {
      _cardPair = NullableCardPair.empty();
    }

    if (_inputMode != PlayerHandSettingInputMode.handRange) {
      _handRange = {};
    }

    notifyListeners();
  }

  NullableCardPair get cardPair => _cardPair;

  Set<HandRangePart> get handRange => _handRange;

  set handRange(Set<HandRangePart> handRange) {
    _handRange = handRange;

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
        ? NullableCardPair(card, _cardPair[1])
        : NullableCardPair(_cardPair[0], card);
    _selectedCardIndex = _selectedCardIndex == 0 ? 1 : 0;

    notifyListeners();
  }
}

abstract class PlayerHandSettingInputMode {
  PlayerHandSettingInputMode._();

  static const cardPair = _PlayerHandSettingInputMode(0);
  static const handRange = _PlayerHandSettingInputMode(1);

  static PlayerHandSettingInputMode fromPlayerHandSettingType(
      PlayerHandSettingType type) {
    switch (type) {
      case PlayerHandSettingType.holeCards:
        return PlayerHandSettingInputMode.cardPair;
      default:
        return PlayerHandSettingInputMode.handRange;
    }
  }

  PlayerHandSettingType toPlayerHandSettingType();
}

class _PlayerHandSettingInputMode implements PlayerHandSettingInputMode {
  const _PlayerHandSettingInputMode(this.value);

  final int value;

  // ignore: missing_return
  PlayerHandSettingType toPlayerHandSettingType() {
    switch (this) {
      case PlayerHandSettingInputMode.cardPair:
        return PlayerHandSettingType.holeCards;
      case PlayerHandSettingInputMode.handRange:
        return PlayerHandSettingType.handRange;
    }
  }
}

const _holeCardSelectorPadding = EdgeInsets.all(16.0);
const _handRangeIndicatorGridPadding =
    EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
const _controlPadding = EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 2.0);
const _holeCardBorderPadding = EdgeInsets.all(4.0);
const _actionsPadding = EdgeInsets.all(16.0);
const _actionsGap = 8.0;
