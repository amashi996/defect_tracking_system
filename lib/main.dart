import 'package:defect_tracking_system/screens/auth/login.dart';
import 'package:defect_tracking_system/screens/defects/all_defects.dart';
import 'package:defect_tracking_system/screens/defects/providers/Defect.dart';
import 'package:defect_tracking_system/screens/home.dart';
import 'package:defect_tracking_system/screens/leaderboard/leaderboard.dart';
import 'package:defect_tracking_system/screens/leaderboard/providers/leaderboard_provider.dart';
import 'package:defect_tracking_system/screens/profile/my_profile.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_provider.dart';
import 'package:defect_tracking_system/screens/reviews/reviews_page.dart';
import 'package:defect_tracking_system/screens/splash.dart';
import 'package:defect_tracking_system/utils/app_route_observer.dart';
import 'package:defect_tracking_system/utils/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NavigationProvider()),
    ChangeNotifierProvider(create: (_) => DefectProvider()),
    ChangeNotifierProvider(create: (_) => ReviewProvider()),
    ChangeNotifierProvider(create: (_) => LeaderboardProvider())
    //  ChangeNotifierProvider(create: (_) => UserProvider())
  ], child: const DefectTrackingApp()));
}

class DefectTrackingApp extends StatelessWidget {
  const DefectTrackingApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Defect Tracking App',
      navigatorObservers: [AppRouteObserver()],
      routes: {
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomeScreen(),
        '/reviews': (_) => ReviewListScreen(),
        '/all-defects': (_) => const AllDefectsPage(),
        '/leaderboard': (_) => const LeaderboardPage(),
        '/profile': (_) => const UserProfilePage(),
        '/splash': (_) => const SplashPage()
      },
      theme: ThemeData(
        listTileTheme: ListTileThemeData(
            selectedTileColor: Colors.blue,
            selectedColor: Colors.white,
            minVerticalPadding: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13))),
        cardTheme: const CardTheme(
          surfaceTintColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        pageTransitionsTheme: PageTransitionsTheme(
          // makes all platforms that can run Flutter apps display routes without any animation
          builders: {
            for (var k in TargetPlatform.values.toList())
              k: const _InanimatePageTransitionsBuilder()
          },
        ),
      ),
      initialRoute: '/splash',
      home: const SplashPage(),
    );
  }
}

class _InanimatePageTransitionsBuilder extends PageTransitionsBuilder {
  const _InanimatePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}
