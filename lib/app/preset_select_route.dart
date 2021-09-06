import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_scaffold.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/readonly_rank_pair_grid.dart";
import "package:aqua/src/constants/hand_range_preset.dart";
import "package:aqua/src/utilities/system_ui_overlay_style.dart";
import "package:aqua/src/view_models/hand_range_draft.dart";
import "package:flutter/cupertino.dart";

class PresetSelectRoute extends CupertinoPageRoute {
  PresetSelectRoute({
    RouteSettings? settings,
  }) : super(
          title: "PresetSelect",
          builder: (context) => _PresetSelectPage(),
          settings: settings,
        );
}

class _PresetSelectPage extends StatefulWidget {
  _PresetSelectPage({Key? key}) : super(key: key);

  @override
  State<_PresetSelectPage> createState() => _PresetSelectPageState();
}

class _PresetSelectPageState extends State<_PresetSelectPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Analytics.of(context).logScreenChange(
        screenName: "Preset Select Screen",
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
      title: "Presets",
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index % 2 == 0) {
                final preset = bundledPresets[index ~/ 2];
                final handRangeDraft =
                    HandRangeDraft.fromHandRange(preset.handRange);

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Analytics.of(context).logEvent(
                      name: "Tap a Preset Item",
                      parameters: {
                        "Preset Name": preset.name,
                        "Hand Range Type": handRangeDraft.type.toString(),
                        "Bundled": true,
                      },
                    );

                    Navigator.of(context).pop(preset);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: ReadonlyRankPairGrid(
                            rankPairs: preset.handRange.onlyRankPairs,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              preset.name,
                              style: theme.textStyleSet.body,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "${(preset.handRange.length / 1326 * 100).floor()}% combs",
                              style: theme.textStyleSet.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SizedBox(height: 16.0);
            },
            childCount: bundledPresets.length * 2 - 1,
          ),
        ),
      ],
    );
  }
}
