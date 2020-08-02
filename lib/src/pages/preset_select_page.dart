import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_scaffold.dart";
import "package:aqua/src/common_widgets/aqua_theme.dart";
import "package:aqua/src/common_widgets/readonly_range_grid.dart";
import "package:aqua/src/constants/player_hand_setting_preset.dart";
import "package:aqua/src/utilities/system_ui_overlay_style.dart";
import "package:flutter/widgets.dart";

class PresetSelectPage extends StatefulWidget {
  PresetSelectPage({Key key}) : super(key: key);

  @override
  State<PresetSelectPage> createState() => _PresetSelectPageState();
}

class _PresetSelectPageState extends State<PresetSelectPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                final playerHandSetting = preset.toPlayerHandSetting();

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Analytics.of(context).logEvent(
                      name: "Tap a Preset Item",
                      parameters: {
                        "Preset Name": preset.name,
                        "Player Hand Setting Type":
                            playerHandSetting.type.toString(),
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
                          child: ReadonlyRangeGrid(
                            handRange: playerHandSetting.handRange,
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
                              "${(playerHandSetting.cardPairCombinations.length / 1326 * 100).floor()}% combs",
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
