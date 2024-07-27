import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:defect_tracking_system/screens/profile/models/user_badge_model.dart';
import 'package:defect_tracking_system/constants/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBadgeProvider with ChangeNotifier {
  List<UserBadge> _userBadges = [];

  List<UserBadge> get userBadges => _userBadges;

  final String apiUrl = Urls.getLoggedUserBadges;

  Future<void> fetchBadges() async {
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
        final List<dynamic> data = json.decode(response.body);
        _userBadges = data.map((badge) => UserBadge.fromJson(badge)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load badges');
      }
    } catch (error) {
      rethrow;
    }
  }
}
