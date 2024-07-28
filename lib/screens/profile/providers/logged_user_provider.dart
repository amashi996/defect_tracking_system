// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:defect_tracking_system/screens/profile/models/logged_user_model.dart';
import 'package:defect_tracking_system/constants/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  Profile? _profile;

  Profile? get profile => _profile;

  final String apiUrl = Urls.getProfileDetails;

  Future<void> fetchLoggedUserProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extracting user name and email from the nested user object
        final userName = data['user']['name'];
        final userEmail = data['user']['email'];

        _profile = Profile.fromJson(data);
        //_profile!.name = userName;
        //_profile!.email = userEmail;

        notifyListeners();
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (error) {
      rethrow;
    }
  }
}
