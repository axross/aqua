import "package:flutter/widgets.dart";

class AquaTabView extends StatefulWidget {
  AquaTabView({
    Key key,
    @required this.views,
    this.activeViewIndex = 0,
  })  : assert(views != null),
        assert(views.length >= 1),
        assert(activeViewIndex < views.length),
        super(key: key);

  final List<Widget> views;

  final int activeViewIndex;

  @override
  State<AquaTabView> createState() => _AquaTabViewState();
}

class _AquaTabViewState extends State<AquaTabView> {
  int _previousActiveViewIndex;

  @override
  void initState() {
    super.initState();

    _previousActiveViewIndex = widget.activeViewIndex;
  }

  @override
  void didUpdateWidget(AquaTabView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activeViewIndex != widget.activeViewIndex) {
      setState(() {
        _previousActiveViewIndex = oldWidget.activeViewIndex;
      });
    }
  }

  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: Tween<double>(begin: 0.5, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: SlideTransition(
            position: _previousActiveViewIndex > widget.activeViewIndex
                ? Tween<Offset>(
                    begin: Offset(-0.05, 0),
                    end: Offset(0, 0),
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ))
                : Tween<Offset>(
                    begin: Offset(0.05, 0),
                    end: Offset(0, 0),
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
            child: child,
          ),
        ),
        child: widget.views[widget.activeViewIndex],
      );
}

// class AquaTabView extends StatefulWidget {
//   AquaTabView({
//     Key key,
//     // this.builder,
//     this.navigatorKey,
//     // this.defaultTitle,
//     this.routes,
//     this.initialRoute,
//     // this.onGenerateRoute,
//     // this.onUnknownRoute,
//     // this.navigatorObservers = const <NavigatorObserver>[],
//     // })  : assert(navigatorObservers != null),
//   })  : assert(routes != null),
//         assert(initialRoute != null),
//         super(key: key);

//   /// The widget builder for the default route of the tab view
//   /// ([Navigator.defaultRouteName], which is `/`).
//   ///
//   /// If a [builder] is specified, then [routes] must not include an entry for `/`,
//   /// as [builder] takes its place.
//   ///
//   /// Rebuilding a [CupertinoTabView] with a different [builder] will not clear
//   /// its current navigation stack or update its descendant. Instead, trigger a
//   /// rebuild from a descendant in its subtree. This can be done via methods such
//   /// as:
//   ///
//   ///  * Calling [State.setState] on a descendant [StatefulWidget]"s [State]
//   ///  * Modifying an [InheritedWidget] that a descendant registered itself
//   ///    as a dependent to.
//   // final WidgetBuilder builder;

//   /// A key to use when building this widget"s [Navigator].
//   ///
//   /// If a [navigatorKey] is specified, the [Navigator] can be directly
//   /// manipulated without first obtaining it from a [BuildContext] via
//   /// [Navigator.of]: from the [navigatorKey], use the [GlobalKey.currentState]
//   /// getter.
//   ///
//   /// If this is changed, a new [Navigator] will be created, losing all the
//   /// tab"s state in the process; in that case, the [navigatorObservers]
//   /// must also be changed, since the previous observers will be attached to the
//   /// previous navigator.
//   final GlobalKey<NavigatorState> navigatorKey;

//   final String initialRoute;

//   /// The title of the default route.
//   // final String defaultTitle;

//   /// This tab view"s routing table.
//   ///
//   /// When a named route is pushed with [Navigator.pushNamed] inside this tab view,
//   /// the route name is looked up in this map. If the name is present,
//   /// the associated [WidgetBuilder] is used to construct a [CupertinoPageRoute]
//   /// that performs an appropriate transition to the new route.
//   ///
//   /// If the tab view only has one page, then you can specify it using [builder] instead.
//   ///
//   /// If [builder] is specified, then it implies an entry in this table for the
//   /// [Navigator.defaultRouteName] route (`/`), and it is an error to
//   /// redundantly provide such a route in the [routes] table.
//   ///
//   /// If a route is requested that is not specified in this table (or by
//   /// [builder]), then the [onGenerateRoute] callback is called to build the page
//   /// instead.
//   ///
//   /// This routing table is not shared with any routing tables of ancestor or
//   /// descendant [Navigator]s.
//   final Map<String, WidgetBuilder> routes;

//   /// The route generator callback used when the tab view is navigated to a named route.
//   ///
//   /// This is used if [routes] does not contain the requested route.
//   // final RouteFactory onGenerateRoute;

//   /// Called when [onGenerateRoute] also fails to generate a route.
//   ///
//   /// This callback is typically used for error handling. For example, this
//   /// callback might always generate a "not found" page that describes the route
//   /// that wasn"t found.
//   ///
//   /// The default implementation pushes a route that displays an ugly error
//   /// message.
//   // final RouteFactory onUnknownRoute;

//   @override
//   _AquaTabViewState createState() => _AquaTabViewState();
// }

// class _AquaTabViewState extends State<AquaTabView> {
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       key: widget.navigatorKey,
//       initialRoute: widget.initialRoute,
//       onGenerateRoute: _onGenerateRoute,
//       onUnknownRoute: _onUnknownRoute,
//     );
//   }

//   Route<dynamic> _onGenerateRoute(RouteSettings settings) {
//     final String name = settings.name;

//     final routeBuilder = widget.routes[name];
//     // String title;

//     // return routeBuilder;

//     return AquaTabPageRoute(
//       builder: routeBuilder,
//       // title: title,
//       settings: settings,
//     );

//     // if (routeBuilder != null) {
//     //   return CupertinoPageRoute<dynamic>(
//     //     builder: routeBuilder,
//     //     title: title,
//     //     settings: settings,
//     //   );
//     // }

//     // if (widget.onGenerateRoute != null) return widget.onGenerateRoute(settings);

//     // return null;
//   }

//   Route<dynamic> _onUnknownRoute(RouteSettings settings) {
//     // assert(() {
//     //   if (widget.onUnknownRoute == null) {
//     throw FlutterError(
//         "Could not find a generator for route $settings in the $runtimeType.\n"
//         "Generators for routes are searched for in the following order:\n"
//         " 1. For the \"/\" route, the \"builder\" property, if non-null, is used.\n"
//         " 2. Otherwise, the \"routes\" table is used, if it has an entry for "
//         "the route.\n"
//         " 3. Otherwise, onGenerateRoute is called. It should return a "
//         "non-null value for any valid route not handled by \"builder\" and \"routes\".\n"
//         " 4. Finally if all else fails onUnknownRoute is called.\n"
//         "Unfortunately, onUnknownRoute was not set.");
//     //   }
//     //   return true;
//     // }());

//     // final Route<dynamic> result = widget.onUnknownRoute(settings);

//     // assert(() {
//     //   if (result == null) {
//     //     throw FlutterError("The onUnknownRoute callback returned null.\n"
//     //         "When the $runtimeType requested the route $settings from its "
//     //         "onUnknownRoute callback, the callback returned null. Such callbacks "
//     //         "must never return null.");
//     //   }
//     //   return true;
//     // }());

//     // return result;
//   }
// }

// class AquaTabPageRoute extends PageRoute {
//   AquaTabPageRoute({
//     @required this.builder,
//     RouteSettings settings,
//     this.maintainState = true,
//     bool fullscreenDialog = false,
//   })  : assert(builder != null),
//         assert(maintainState != null),
//         assert(fullscreenDialog != null),
//         super(settings: settings, fullscreenDialog: fullscreenDialog);

//   /// Builds the primary contents of the route.
//   final WidgetBuilder builder;

//   @override
//   final opaque = true;

//   final transitionDuration = const Duration(milliseconds: 200);

//   @override
//   final barrierDismissible = false;

//   @override
//   final barrierColor = null;

//   @override
//   final barrierLabel = null;

//   @override
//   final bool maintainState;

//   @override
//   bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
//     return nextRoute is AquaTabPageRoute && !nextRoute.fullscreenDialog;
//   }

//   // @override
//   // bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) => previousRoute is PageRoute;

//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     final Widget child = builder(context);
//     final Widget result = Semantics(
//       scopesRoute: true,
//       explicitChildNodes: true,
//       child: child,
//     );

//     assert(() {
//       if (child == null) {
//         throw FlutterError.fromParts(<DiagnosticsNode>[
//           ErrorSummary(
//               'The builder for route "${settings.name}" returned null.'),
//           ErrorDescription('Route builders must never return null.'),
//         ]);
//       }

//       return true;
//     }());

//     return result;
//   }

//   @override
//   Widget buildTransitions(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//     Widget child,
//   ) {
//     return FadeTransition(
//       opacity: Tween<double>(begin: 0, end: 1).animate(
//         CurvedAnimation(
//           parent: animation,
//           curve: Curves.easeInOutExpo,
//         ),
//       ),
//       child: ScaleTransition(
//         scale: Tween<double>(begin: 0.95, end: 1).animate(
//           CurvedAnimation(
//             parent: animation,
//             curve: Curves.easeInOutExpo,
//           ),
//         ),
//         child: child,
//       ),
//     );
//   }
// }
