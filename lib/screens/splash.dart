import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    //Navigator.pushReplacementNamed(context, '/login');
    super.initState();

    getTokenFromStorage();
  }

  Future<void> getTokenFromStorage() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? tokenValue = preferences.getString('token');

    if (mounted) {
      // Navigator.of(context).pushReplacementNamed('/home');
      if (tokenValue == null || tokenValue.isEmpty) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
