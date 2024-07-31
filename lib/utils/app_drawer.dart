import 'package:flutter/material.dart';
import '../constants/route_names.dart';
import 'app_route_observer.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({required this.permanentlyDisplay, super.key});

  final bool permanentlyDisplay;

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with RouteAware {
  late String _selectedRoute;
  late AppRouteObserver _routeObserver;
  @override
  void initState() {
    super.initState();
    _routeObserver = AppRouteObserver();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _updateSelectedRoute();
  }

  @override
  void didPop() {
    _updateSelectedRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Row(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: drawerPages(context),
            ),
          ),
          if (widget.permanentlyDisplay)
            const VerticalDivider(
              width: 1,
            )
        ],
      ),
    );
  }
  Future<void> _navigateTo(BuildContext context, String routeName) async {
    if (widget.permanentlyDisplay) {
      Navigator.pop(context);
    }
    await Navigator.pushNamed(context, routeName);
  }

  List<Widget> drawerPages(BuildContext context) {
    //final navigationProvider = Provider.of<NavigationProvider>(context);

    return [
       DrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: CircleAvatar(
            radius: 40,
            child: Icon(
              Icons.account_circle,
              size: 40,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 10, 4),
        child: ListTile(
          leading: const Icon(Icons.home),
          title: const Text("Home"),
          onTap: () async {
            await _navigateTo(context, RouteNames.home);
          },
          selected: _selectedRoute == RouteNames.home,
          style: Theme.of(context).listTileTheme.style,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 10, 4),
        child: ListTile(
          leading: const Icon(Icons.rate_review),
          title: const Text("Reviews"),
          onTap: () async {
            await _navigateTo(context, RouteNames.reviews);
          },
          selected: _selectedRoute == RouteNames.reviews,
          style: Theme.of(context).listTileTheme.style,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 10, 4),
        child: ListTile(
          leading: const Icon(Icons.bug_report),
          title: const Text("Defects"),
          onTap: () async {
            await _navigateTo(context, RouteNames.defects);
          },
          selected: _selectedRoute == RouteNames.defects,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 10, 4),
        child: ListTile(
          leading: const Icon(Icons.leaderboard),
          title: const Text('Leaderboard'),
          onTap: () async {
            await _navigateTo(context, RouteNames.leaderboard);
          },
          selected: _selectedRoute == RouteNames.leaderboard,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 10, 4),
        child: ListTile(
          leading: const Icon(Icons.account_circle_rounded),
          title: const Text('Profile'),
          onTap: () async {
            await _navigateTo(context, RouteNames.profile);
          },
          selected: _selectedRoute == RouteNames.profile,
        ),
      ),
    ];
  }

  void _updateSelectedRoute() {
    setState(() {
      _selectedRoute = ModalRoute.of(context)!.settings.name!;
    });
  }
}
