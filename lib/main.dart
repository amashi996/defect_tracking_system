import 'package:defect_tracking_system/screens/auth/login.dart';
import 'package:defect_tracking_system/screens/home.dart';
import 'package:defect_tracking_system/screens/splash.dart';
import 'package:defect_tracking_system/utils/app_route_observer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DefectTrackingApp());
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
        '/home': (_) => const HomeScreen()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      home: const SplashPage(),
    );
  }
}
