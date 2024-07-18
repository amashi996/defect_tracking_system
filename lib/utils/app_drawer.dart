import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:defect_tracking_system/utils/navigation_provider.dart';

import '../constants/route_names.dart';
import 'app_route_observer.dart';

/// The navigation drawer for the app.
/// This listens to changes in the route to update which page is currently been shown
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

  /// Closes the drawer if applicable (which is only when it's not been displayed permanently) and navigates to the specified route
  /// In a mobile layout, the a modal drawer is used so we need to explicitly close it when the user selects a page to display
  Future<void> _navigateTo(BuildContext context, String routeName) async {
    if (widget.permanentlyDisplay) {
      Navigator.pop(context);
    }
    await Navigator.pushNamed(context, routeName);
  }

  List<Widget> drawerPages(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return [
      const UserAccountsDrawerHeader(
        accountName: Text("Name Here"),
        accountEmail: Text("email@here.com"),
        currentAccountPicture: CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
              "https://avatars.githubusercontent.com/u/40816448?v=4"),
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
          //selected: navigationProvider.selectedMenu == RouteNames.categories,
          style: Theme.of(context).listTileTheme.style,
          // style: Listst,
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
          //selected: navigationProvider.selectedMenu == RouteNames.reviews,
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
      // ListTile(
      //   leading: NavPageIcons.favouriteIcon,
      //   title: const Text(PageTitles.volunteer),
      //   onTap: () async {
      //     await _navigateTo(context, RouteNames.volunteer);
      //   },
      //   selected: _selectedRoute == RouteNames.volunteer,
      // ),
      // ListTile(
      //   leading: NavPageIcons.codeIcon,
      //   title: const Text(PageTitles.projects),
      //   onTap: () async {
      //     await _navigateTo(context, RouteNames.projects);
      //   },
      //   selected: _selectedRoute == RouteNames.projects,
      // ),
      // ListTile(
      //   leading: NavPageIcons.localPlayIcon,
      //   title: const Text(PageTitles.awards),
      //   onTap: () async {
      //     await _navigateTo(context, RouteNames.awards);
      //   },
      //   selected: _selectedRoute == RouteNames.awards,
      // ),
      // // ListTile(
      // //   leading: NavPageIcons.buildIcon,
      // //   title: const Text(PageTitles.skills),
      // //   onTap: () async {
      // //     await _navigateTo(context, RouteNames.skills);
      // //   },
      // //   selected: _selectedRoute == RouteNames.skills,
      // // ),
      // ListTile(
      //   leading: NavPageIcons.article,
      //   title: const Text(PageTitles.publications),
      //   onTap: () async {
      //     await _navigateTo(context, RouteNames.publications);
      //   },
      //   selected: _selectedRoute == RouteNames.publications,
      // ),
      // ListTile(
      //   leading: SvgPicture.asset(
      //     'assets/svg/fireabse.svg',
      //     width: 24,
      //     height: 24,
      //   ),
      //   title: const Text(PageTitles.certifications),
      //   onTap: () async {
      //     await _navigateTo(context, RouteNames.certifications);
      //   },
      //   selected: _selectedRoute == RouteNames.certifications,
      // ),
      // ListTile(
      //   leading: NavPageIcons.mailIcon,
      //   title: const Text(PageTitles.contact),
      //   onTap: () async {
      //     await _navigateTo(context, RouteNames.contact);
      //   },
      //   selected: _selectedRoute == RouteNames.contact,
      // ),
      // const Divider(thickness: 2),
      // ListTile(
      //   leading: const Icon(Icons.settings),
      //   title: const Text(PageTitles.settings),
      //   onTap: () async {
      //     await _navigateTo(context, RouteNames.settings);
      //   },
      //   selected: _selectedRoute == RouteNames.settings,
      // ),
    ];
  }

  void _updateSelectedRoute() {
    setState(() {
      _selectedRoute = ModalRoute.of(context)!.settings.name!;
    });
  }
}
