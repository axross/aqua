import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_button.dart";
import "package:aqua/src/common_widgets/aqua_icons.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:flutter/widgets.dart";

@immutable
class AquaScadffold extends StatelessWidget {
  AquaScadffold({
    Key key,
    this.scrollController,
    this.title = "Title",
    this.actions = const [],
    this.slivers = const [],
  }) : super(key: key);

  final ScrollController scrollController;

  final String title;

  final List<Widget> actions;

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    final theme = AquaTheme.of(context);
    final style = theme.scaffoldStyle;
    final defaultActionButtonStyle =
        theme.buttonStyleSet[style.defaultActionButtonvariant];

    return Container(
      color: style.backgroundColor,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverSafeArea(
            sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (Navigator.of(context).canPop()) ...[
                          AquaButton(
                            variant: AquaButtonVariant.secondary,
                            icon: AquaIcons.chevronLeft,
                            onTap: () {
                              Analytics.of(context).logEvent(
                                name: "Tap a Scaffold Back Button",
                              );

                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: 16),
                        ],
                        Text(
                          title,
                          textAlign: TextAlign.start,
                          style: style.titleTextStyle,
                        ),
                      ],
                    ),
                    DefaultAquaButtonStyle(
                      style: defaultActionButtonStyle,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: actions,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ...slivers,
          SliverSafeArea(
            bottom: true,
            sliver: SliverPadding(
              padding: EdgeInsets.only(bottom: 64.0),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class AquaScaffoldStyle {
  const AquaScaffoldStyle({
    @required this.titleTextStyle,
    this.defaultActionButtonvariant = AquaButtonVariant.secondary,
    @required this.backgroundColor,
  });

  final TextStyle titleTextStyle;

  final AquaButtonVariant defaultActionButtonvariant;

  final Color backgroundColor;
}
