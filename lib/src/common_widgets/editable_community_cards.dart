import "dart:ui" show ImageFilter;
import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_button.dart";
import "package:aqua/src/common_widgets/aqua_icons.dart";
import "package:aqua/src/common_widgets/aqua_popup_transition.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/card_picker.dart";
import "package:aqua/src/common_widgets/playing_card.dart";
import "package:flutter/widgets.dart";
import "package:poker/poker.dart";

class EditableCommunityCards extends StatefulWidget {
  EditableCommunityCards({
    required this.initialCommunityCards,
    this.unavailableCards = CardSet.empty,
    this.isPopupOpen = false,
    this.prepareForPopup,
    this.onTapChangeTarget,
    this.onTapCardPicker,
    this.onTapClear,
    this.onOpenPopup,
    this.onClosedPopup,
    required this.onRequestClose,
    Key? key,
  })  : assert(initialCommunityCards.length <= 5),
        super(key: key);

  final CardSet initialCommunityCards;

  final CardSet unavailableCards;

  final bool isPopupOpen;

  final Future<void> Function(Rect overlayRect)? prepareForPopup;

  final void Function(int index)? onTapChangeTarget;

  final void Function(Card card)? onTapCardPicker;

  final VoidCallback? onTapClear;

  final VoidCallback? onOpenPopup;

  final Function(CardSet communityCards)? onClosedPopup;

  final VoidCallback onRequestClose;

  @override
  State<EditableCommunityCards> createState() => _EditableCommunityCardsState();
}

class _EditableCommunityCardsState extends State<EditableCommunityCards>
    with TickerProviderStateMixin {
  final _key = GlobalKey();

  late _EditableCommunityCardsStateBus _stateBus;

  late AnimationController _animationController;

  late AnimationController _popupElementsAnimationController;

  late Animation<double> _curvedAnimation;

  late Animation<double> _popupElementsCurvedAnimation;

  OverlayEntry? _touchAbsorverEntry;

  List<OverlayEntry> _overlayEntries = [];

  @override
  void initState() {
    super.initState();

    _stateBus = _EditableCommunityCardsStateBus(
      initialCommunityCards: widget.initialCommunityCards,
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
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        if (widget.isPopupOpen) {
          _openPopup();
        } else {
          _closePopup();
        }
      });
    }
  }

  Future<void> _openPopup() async {
    if (_touchAbsorverEntry != null) return;

    if (widget.onOpenPopup != null) {
      widget.onOpenPopup!();
    }

    final overlayState = Overlay.of(_key.currentContext!, rootOverlay: true)!;

    final touchAbsorverEntry = OverlayEntry(
      builder: (context) => _buildTouchAbsorber(context),
    );
    _touchAbsorverEntry = touchAbsorverEntry;
    overlayState.insert(touchAbsorverEntry);

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

    _touchAbsorverEntry!.remove();
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
      widget.onClosedPopup!(_stateBus.toCardSet());
    }
  }

  Future<void> _prepareOpenPopup() async {
    if (widget.prepareForPopup != null) {
      // calculate picker global offset before scroll/reposition
      // this global offset will change after prepareForPopup()
      await widget.prepareForPopup!(
        _getTargetCardSelectorRect()
            .expandToInclude(_getCardPickerRect())
            .expandToInclude(_getActionsRect()),
      );
    }
  }

  Rect _getTargetCardSelectorRect() {
    final childRenderBox = _key.currentContext!.findRenderObject() as RenderBox;
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
    final indicatorRect = _getTargetCardSelectorRect();
    final mediaQuery = MediaQuery.of(context);

    return Rect.fromLTRB(
      mediaQuery.padding.left + _actionsPadding.left,
      indicatorRect.top - _actionsPadding.top - aquaButtonHeight,
      mediaQuery.size.width - mediaQuery.padding.right - _actionsPadding.right,
      indicatorRect.top,
    );
  }

  _buildTouchAbsorber(BuildContext context) => Positioned.fill(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: SizedBox.expand(),
        ),
      );

  _buildCurtain(BuildContext context) => Positioned.fill(
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
            onTap: widget.onRequestClose,
            child: SizedBox.expand(),
          ),
        ),
      );

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
                        boxShadow: AquaTheme.of(context).elevationBoxShadows,
                      ),
                    ).animate(_popupElementsCurvedAnimation),
                    child: AquaButton(
                      variant: AquaButtonVariant.normal,
                      label: "Clear",
                      icon: AquaIcons.backspace,
                      onTap: () {
                        if (widget.onTapClear != null) {
                          widget.onTapClear!();
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
                      color: _stateBus.replacementTargetIndex == index
                          ? theme.cursorColor
                          : theme.cursorColor.withOpacity(0.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ).animate(_popupElementsCurvedAnimation),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.onTapChangeTarget != null) {
                        widget.onTapChangeTarget!(index);
                      }

                      _stateBus.replacementTargetIndex = index;
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
                            boxShadow: theme.elevationBoxShadows,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ).animate(_popupElementsCurvedAnimation),
                        child: AnimatedBuilder(
                          animation: _stateBus,
                          builder: (context, _) => _stateBus[index] != null
                              ? PlayingCard(card: _stateBus[index])
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
                boxShadow: AquaTheme.of(context).elevationBoxShadows,
                borderRadius: BorderRadius.circular(8),
              ),
              child: AnimatedBuilder(
                animation: _stateBus,
                builder: (context, _) => CardPicker(
                  unavailableCards:
                      widget.unavailableCards.union(_stateBus.toCardSet()),
                  onCardTap: (card) {
                    if (widget.onTapCardPicker != null) {
                      widget.onTapCardPicker!(card);
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
  Widget build(BuildContext context) => SizedBox(
        key: _key,
        child: LayoutBuilder(
          builder: (context, constraints) => AnimatedBuilder(
            animation: _stateBus,
            builder: (context, _) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: (constraints.maxWidth - 8 * 4) / 5,
                  child: _stateBus[0] != null
                      ? PlayingCard(card: _stateBus[0])
                      : PlayingCardBack(),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: (constraints.maxWidth - 8 * 4) / 5,
                  child: _stateBus[1] != null
                      ? PlayingCard(card: _stateBus[1])
                      : PlayingCardBack(),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: (constraints.maxWidth - 8 * 4) / 5,
                  child: _stateBus[2] != null
                      ? PlayingCard(card: _stateBus[2])
                      : PlayingCardBack(),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: (constraints.maxWidth - 8 * 4) / 5,
                  child: _stateBus[3] != null
                      ? PlayingCard(card: _stateBus[3])
                      : PlayingCardBack(),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: (constraints.maxWidth - 8 * 4) / 5,
                  child: _stateBus[4] != null
                      ? PlayingCard(card: _stateBus[4])
                      : PlayingCardBack(),
                ),
              ],
            ),
          ),
        ),
      );
}

class _EditableCommunityCardsStateBus extends ChangeNotifier {
  _EditableCommunityCardsStateBus({required CardSet initialCommunityCards})
      : assert(initialCommunityCards.length <= 5),
        _cards = [null, null, null, null, null]
          ..setRange(0, initialCommunityCards.length, initialCommunityCards),
        _replacementTargetIndex = 0;

  List<Card?> _cards;

  int _replacementTargetIndex;

  int get replacementTargetIndex => _replacementTargetIndex;

  set replacementTargetIndex(int index) {
    _replacementTargetIndex = index;

    notifyListeners();
  }

  void setCard(Card card) {
    _cards[_replacementTargetIndex] = card;
    _replacementTargetIndex = (_replacementTargetIndex + 1) % 5;

    notifyListeners();
  }

  void clearCards() {
    _cards = [null, null, null, null, null];
    _replacementTargetIndex = 0;

    notifyListeners();
  }

  // CardSet toCardSet() => CardSet(_cards.where((c) => c != null))
  CardSet toCardSet() => CardSet(_cards.whereType<Card>());

  operator [](index) {
    assert(index != null);
    assert(index >= 0 && index < 5);

    return _cards[index];
  }
}

const _targetCardSelectorPadding = EdgeInsets.symmetric(
  vertical: 16.0,
  horizontal: 4.0,
);
const _cardPickerPadding = EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 2.0);
const _selectedCardBorderPadding = EdgeInsets.all(4.0);
const _actionsPadding = EdgeInsets.all(16.0);
