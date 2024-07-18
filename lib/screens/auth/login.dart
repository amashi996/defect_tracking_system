import 'dart:convert';

import 'package:defect_tracking_system/constants/urls/urls.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  //bool _rememberMe = false;
  bool _showPassword = true;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    // Replace this URL with your actual API endpoint
    final String apiUrl = Urls.loginUser;

    final Map<String, String> data = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token =
          responseData['token']; // Extract token from 'data' object
      // Save token to SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Navigate to home page
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show alert dialog for incorrect password
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sign In Failed'),
            content: const Text('Incorrect email or password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                ClipOval(
                  child: SvgPicture.asset(
                    'assets/logo.svg',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ), // Replace with your logo asset path
                ),
                const SizedBox(height: 20),
                // Welcome Text
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Username Field
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email ID',
                    hintText: "username@domain.com",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: _showPassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: GestureDetector(
                      child: _showPassword
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onTap: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Remember Me and Forgot Password
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       children: [
                //         Checkbox(
                //           value: _rememberMe,
                //           onChanged: (bool? value) {
                //             setState(() {
                //               _rememberMe = value!;
                //             });
                //           },
                //         ),
                //         const Text('Remember me'),
                //       ],
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         // Implement forgot password functionality here
                //         print('Forgot Password Pressed');
                //       },
                //       child: const Text(
                //         'Forgot Password?',
                //         style: TextStyle(
                //           color: Colors.blue,
                //           //decoration: TextDecoration.underline,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 20),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _login,
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                    backgroundColor: Colors.blue,
                                    strokeWidth: 3,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Signing In..."),
                              ],
                            ),
                          )
                        : const Text('Sign In'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
