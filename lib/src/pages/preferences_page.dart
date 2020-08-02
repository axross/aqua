import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_scaffold.dart";
import 'package:aqua/src/common_widgets/aqua_theme.dart';
import 'package:aqua/src/utilities/system_ui_overlay_style.dart';
import "package:flutter/widgets.dart";

class PreferencesPage extends StatefulWidget {
  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Analytics.of(context).logScreenChange(
        screenName: "Preferences Screen",
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
    return AquaScadffold(
      title: "Preferences",
      slivers: [],
    );
  }
}
