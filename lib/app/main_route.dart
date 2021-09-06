import "package:aqua/app/main_route/preferences_tab_page.dart";
import "package:aqua/app/main_route/simulation_tab_page.dart";
import "package:aqua/src/common_widgets/analytics.dart";
import "package:aqua/src/common_widgets/aqua_icons.dart";
import "package:aqua/src/common_widgets/aqua_tab_bar.dart";
import "package:aqua/src/common_widgets/aqua_tab_view.dart";
import "package:aqua/src/view_models/simulation_session.dart";
import "package:flutter/cupertino.dart";

class MainRoute extends CupertinoPageRoute {
  MainRoute({
    RouteSettings? settings,
  }) : super(
          title: "Main",
          builder: (context) => _MainPage(),
          settings: settings,
        );
}

class _MainPage extends StatefulWidget {
  @override
  State<_MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  late int _activeTabViewIndex;

  /// A ValueNotifier that holds a CalculationSession inside.
  /// Replace the held CalculationSession to start a new session
  late ValueNotifier<CalculationSession> _calculationSession;

  @override
  void initState() {
    super.initState();

    _activeTabViewIndex = 0;

    late CalculationSession calculationSession;
    calculationSession = CalculationSession.initial(
      onStartCalculation: (_, __) {
        Analytics.of(context).logEvent(
          name: "Start Simulation",
          parameters: {
            "Number of Community Cards":
                calculationSession.communityCards.toSet().length,
            "Number of Hand Ranges": calculationSession.players.length,
          },
        );
      },
      onFinishCalculation: (snapshot) {
        Analytics.of(context).logEvent(
          name: "Finish Simulation",
          parameters: {
            "Number of Community Cards":
                calculationSession.communityCards.toSet().length,
            "Number of Hand Ranges": calculationSession.players.length,
          },
        );
      },
    );

    _calculationSession = ValueNotifier(calculationSession);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CalculationSession>(
      valueListenable: _calculationSession,
      builder: (context, calculationSession, _) => Container(
        color: Color(0xffffffff),
        child: Column(
          children: [
            Expanded(
              child: AquaTabView(
                views: [
                  SimulationTabPage(
                    key: ValueKey(0),
                    calculationSession: calculationSession,
                  ),
                  PreferencesTabPage(key: ValueKey(1)),
                ],
                activeViewIndex: _activeTabViewIndex,
              ),
            ),
            AquaTabBar(
              activeIndex: _activeTabViewIndex,
              onChanged: (index) {
                setState(() {
                  _activeTabViewIndex = index;
                });
              },
              items: [
                AquaTabBarItem(label: "Calculation", icon: AquaIcons.percent),
                AquaTabBarItem(label: "Preferences", icon: AquaIcons.gear),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
