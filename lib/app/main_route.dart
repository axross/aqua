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
    RouteSettings settings,
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
  int _activeTabViewIndex;

  /// A ValueNotifier that holds a SimulationSession inside.
  /// Replace the held SimulationSession to start a new session
  ValueNotifier<SimulationSession> _simulationSession;

  @override
  void initState() {
    super.initState();

    _activeTabViewIndex = 0;

    SimulationSession simulationSession;

    simulationSession = SimulationSession.initial(
      onStartSimulation: () {
        Analytics.of(context).logEvent(
          name: "Start Simulation",
          parameters: {
            "Number of Community Cards":
                simulationSession.communityCards.toSet().length,
            "Number of Hand Ranges": simulationSession.handRanges.length,
          },
        );
      },
      onFinishSimulation: (snapshot) {
        Analytics.of(context).logEvent(
          name: "Finish Simulation",
          parameters: {
            "Number of Community Cards":
                simulationSession.communityCards.toSet().length,
            "Number of Hand Ranges": simulationSession.handRanges.length,
          },
        );
      },
    );

    _simulationSession = ValueNotifier(simulationSession);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _simulationSession,
      builder: (context, simulationSession, _) => Container(
        color: Color(0xffffffff),
        child: Column(
          children: [
            Expanded(
              child: AquaTabView(
                views: [
                  SimulationTabPage(
                    key: ValueKey(0),
                    simulationSession: simulationSession,
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
