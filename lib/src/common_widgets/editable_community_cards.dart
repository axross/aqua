import "dart:ui";
import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_button.dart";
import "package:aqua/src/common_widgets/aqua_icons.dart";
import "package:aqua/src/common_widgets/aqua_popup_transition.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/card_picker.dart";
import "package:aqua/src/common_widgets/playing_card.dart";
import "package:aqua/src/models/community_cards.dart";
import "package:flutter/widgets.dart";
import "package:poker/poker.dart";

class EditableCommunityCards extends StatefulWidget {
  EditableCommunityCards({
    this.initialCommunityCards,
    this.unavailableCards = const {},
    this.isPopupOpen = false,
    this.prepareForPopup,
    this.onTapChangeTarget,
    this.onTapCardPicker,
    this.onTapClear,
    this.onOpenPopup,
    this.onClosedPopup,
    this.onRequestClose,
    Key key,
  }) : super(key: key);

  final CommunityCards initialCommunityCards;

  final Set<Card> unavailableCards;

  final bool isPopupOpen;

  final Future<void> Function(Rect overlayPosition) prepareForPopup;

  final void Function(int index) onTapChangeTarget;

  final void Function(Card card) onTapCardPicker;

  final VoidCallback onTapClear;

  final VoidCallback onOpenPopup;

  final Function(CommunityCards communityCards) onClosedPopup;

  final VoidCallback onRequestClose;

  @override
  State<EditableCommunityCards> createState() => _EditableCommunityCardsState();
}

class _EditableCommunityCardsState extends State<EditableCommunityCards>
    with TickerProviderStateMixin {
  final _key = GlobalKey();

  _EditableCommunityCardsStateBus _stateBus;

  AnimationController _animationController;

  AnimationController _popupElementsAnimationController;

  Animation _curvedAnimation;

  Animation _popupElementsCurvedAnimation;

  OverlayEntry _touchAbsorverEntry;

  List<OverlayEntry> _overlayEntries = [];

  @override
  void initState() {
    super.initState();

    _stateBus = _EditableCommunityCardsStateBus(
      initialCommunityCards:
          widget.initialCommunityCards ?? CommunityCards.empty(),
      initialUnavailableCards: widget.unavailableCards,
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
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (widget.isPopupOpen) {
          _openPopup();
        } else {
          _closePopup();
        }
      });
    }

    if (widget.unavailableCards != oldWidget.unavailableCards) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _stateBus.unavailableCards = widget.unavailableCards;
      });
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
      screenName: "Community Cards Editor Popup",
    );

    _overlayEntries = [
      OverlayEntry(
        builder: (context) => _buildCurtain(context),
      ),
      OverlayEntry(
        builder: (context) => _buildActions(context),
      ),
      OverlayEntry(
        builder: (context) => _buildTargetCardSelector(context),
        // opaque: true,
        maintainState: true,
      ),
      OverlayEntry(builder: (context) => _buildCardPicker(context)),
    ];

    overlayState.insertAll(_overlayEntries);

    await Future.wait([
      _animationController.forward(),
      _popupElementsAnimationController.forward(),
    ]);
  }

  Future<void> _closePopup() async {
    if (_touchAbsorverEntry == null) return;

    _touchAbsorverEntry.remove();
    _touchAbsorverEntry = null;

    await Future.wait([
      _animationController.reverse(),
      _popupElementsAnimationController.reverse(),
    ]);

    for (final entry in _overlayEntries) {
      entry.remove();
    }

    _overlayEntries = [];

    if (widget.onClosedPopup != null) {
      widget.onClosedPopup(_stateBus.communityCards);
    }
  }

  Future<void> _prepareOpenPopup() async {
    if (widget.prepareForPopup != null) {
      // calculate picker global offset before scroll/reposition
      // this global offset will change after prepareForPopup()
      final targetCardSelectorRect = _getTargetCardSelectorRect();
      final cardPickerSize = _getCardPickerSize();

      await widget.prepareForPopup(
        targetCardSelectorRect.topLeft &
            cardPickerSize + Offset(0.0, targetCardSelectorRect.height),
      );
    }
  }

  Rect _getTargetCardSelectorRect() {
    final RenderBox childRenderBox = _key.currentContext.findRenderObject();
    final holeCardSelectorSize = childRenderBox.size +
        Offset(
          _targetCardSelectorPadding.horizontal,
          _targetCardSelectorPadding.vertical,
        );

    return childRenderBox
                .localToGlobal(holeCardSelectorSize.topLeft(Offset.zero)) -
            Offset(
              _targetCardSelectorPadding.left,
              _targetCardSelectorPadding.top,
            ) &
        holeCardSelectorSize;
  }

  Rect _getCardPickerRect() =>
      Offset(0.0, _getTargetCardSelectorRect().bottom) & _getCardPickerSize();

  Size _getCardPickerSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    final playingCardAspectRatio = 2.25 / 3.5;
    final cardGap = 2.0;

    return Size(
      screenWidth,
      (screenWidth - _cardPickerPadding.horizontal - cardGap * 12) /
              13 /
              playingCardAspectRatio *
              4 +
          cardGap * 3 +
          _cardPickerPadding.vertical,
    );
  }

  Rect _getActionsRect() {
    final indicatorPosition = _getTargetCardSelectorRect();
    final mediaQuery = MediaQuery.of(context);

    return Rect.fromLTRB(
      mediaQuery.padding.left + _actionsPadding.left,
      indicatorPosition.top - _actionsPadding.top - aquaButtonHeight,
      mediaQuery.size.width - mediaQuery.padding.right - _actionsPadding.right,
      indicatorPosition.top,
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

  _buildCurtain(BuildContext context) {
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
            decoration: DecorationTween(
              begin: BoxDecoration(color: Color(0x1f000000)),
              end: BoxDecoration(color: Color(0x1f000000)),
            ).animate(_curvedAnimation),
            child: child,
          ),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onRequestClose,
          child: SizedBox.expand(),
        ),
      ),
    );
  }

  _buildActions(BuildContext context) => Positioned.fromRect(
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
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1f000000),
                            blurRadius: 12,
                          ),
                          BoxShadow(
                            color: Color(0x0f000000),
                            offset: Offset(0, 12),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                    ).animate(_popupElementsCurvedAnimation),
                    child: AquaButton(
                      variant: AquaButtonVariant.normal,
                      label: "Clear",
                      icon: AquaIcons.backspace,
                      onTap: () {
                        if (widget.onTapClear != null) {
                          widget.onTapClear();
                        }

                        _stateBus.clearCards();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  _buildTargetCardSelector(BuildContext context) {
    final theme = AquaTheme.of(context);
    final holeCardSelectorRect = _getTargetCardSelectorRect();

    return Positioned.fromRect(
      rect: holeCardSelectorRect,
      child: Padding(
        padding: _targetCardSelectorPadding - _selectedCardBorderPadding,
        child: AnimatedBuilder(
          animation: _stateBus,
          builder: (context, _) => Row(
            children: List.generate(
              5,
              (index) => SizedBox(
                width: holeCardSelectorRect.width / 5,
                child: DecoratedBoxTransition(
                  decoration: DecorationTween(
                    begin: BoxDecoration(
                      color: theme.cursorColor.withOpacity(0.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    end: BoxDecoration(
                      color: _stateBus.selectedCardIndex == index
                          ? theme.cursorColor
                          : theme.cursorColor.withOpacity(0.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ).animate(_popupElementsCurvedAnimation),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.onTapChangeTarget != null) {
                        widget.onTapChangeTarget(index);
                      }

                      _stateBus.selectedCardIndex = index;
                    },
                    child: Padding(
                      padding: _selectedCardBorderPadding,
                      child: DecoratedBoxTransition(
                        decoration: DecorationTween(
                          begin: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          end: BoxDecoration(
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x1f000000),
                                offset: Offset(0, 0),
                                blurRadius: 12,
                              ),
                              BoxShadow(
                                color: const Color(0x0f000000),
                                offset: Offset(0, 12),
                                blurRadius: 24,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ).animate(_popupElementsCurvedAnimation),
                        child: AnimatedBuilder(
                          animation: _stateBus,
                          builder: (context, _) =>
                              _stateBus.communityCards[index] != null
                                  ? PlayingCard(
                                      card: _stateBus.communityCards[index],
                                    )
                                  : PlayingCardBack(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildCardPicker(BuildContext context) => Positioned.fromRect(
        rect: _getCardPickerRect(),
        child: AquaPopupTransition(
          animation: _popupElementsCurvedAnimation,
          child: Padding(
            padding: _cardPickerPadding,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1f000000),
                    offset: Offset(0, 0),
                    blurRadius: 12,
                  ),
                  BoxShadow(
                    color: const Color(0x0f000000),
                    offset: Offset(0, 12),
                    blurRadius: 24,
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: AnimatedBuilder(
                animation: _stateBus,
                builder: (context, _) => CardPicker(
                  unavailableCards: {
                    ..._stateBus.unavailableCards,
                    ..._stateBus.communityCards,
                  },
                  onCardTap: (card) {
                    if (widget.onTapCardPicker != null) {
                      widget.onTapCardPicker(card);
                    }

                    _stateBus.setCard(card);
                  },
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _key,
      child: LayoutBuilder(
        builder: (context, constraints) => AnimatedBuilder(
          animation: _stateBus,
          builder: (context, _) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: (constraints.maxWidth - 8 * 4) / 5,
                child: _stateBus.communityCards[0] != null
                    ? PlayingCard(card: _stateBus.communityCards[0])
                    : PlayingCardBack(),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: (constraints.maxWidth - 8 * 4) / 5,
                child: _stateBus.communityCards[1] != null
                    ? PlayingCard(card: _stateBus.communityCards[1])
                    : PlayingCardBack(),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: (constraints.maxWidth - 8 * 4) / 5,
                child: _stateBus.communityCards[2] != null
                    ? PlayingCard(card: _stateBus.communityCards[2])
                    : PlayingCardBack(),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: (constraints.maxWidth - 8 * 4) / 5,
                child: _stateBus.communityCards[3] != null
                    ? PlayingCard(card: _stateBus.communityCards[3])
                    : PlayingCardBack(),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: (constraints.maxWidth - 8 * 4) / 5,
                child: _stateBus.communityCards[4] != null
                    ? PlayingCard(card: _stateBus.communityCards[4])
                    : PlayingCardBack(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditableCommunityCardsStateBus extends ChangeNotifier {
  _EditableCommunityCardsStateBus({
    @required CommunityCards initialCommunityCards,
    @required Set<Card> initialUnavailableCards,
  })  : assert(initialCommunityCards != null),
        assert(initialUnavailableCards != null),
        _communityCards = initialCommunityCards,
        _unavailableCards = initialUnavailableCards,
        _selectedCardIndex = 0;

  CommunityCards _communityCards;

  int _selectedCardIndex;

  Set<Card> _unavailableCards;

  CommunityCards get communityCards => _communityCards;

  int get selectedCardIndex => _selectedCardIndex;

  set selectedCardIndex(int index) {
    if (_communityCards.length - 1 < index) {
      _selectedCardIndex = _communityCards.length - 1;
    } else {
      _selectedCardIndex = index;
    }

    notifyListeners();
  }

  Set<Card> get unavailableCards => _unavailableCards;

  set unavailableCards(Set<Card> cards) {
    _unavailableCards = cards;

    notifyListeners();
  }

  setCard(Card card) {
    _communityCards = CommunityCards([..._communityCards]);
    _communityCards[_selectedCardIndex] = card;
    _selectedCardIndex = (_selectedCardIndex + 1) % 5;

    notifyListeners();
  }

  clearCards() {
    _communityCards = CommunityCards.empty();
    _selectedCardIndex = 0;

    notifyListeners();
  }
}

const _targetCardSelectorPadding = EdgeInsets.symmetric(
  vertical: 16.0,
  horizontal: 4.0,
);
const _cardPickerPadding = EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 2.0);
const _selectedCardBorderPadding = EdgeInsets.all(4.0);
const _actionsPadding = EdgeInsets.all(16.0);
