// providers/achievement_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:defect_tracking_system/screens/profile/models/user_achievement_model.dart';
import 'package:defect_tracking_system/constants/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAchievementProvider with ChangeNotifier {
  List<UserAchievement> _userAchievements = [];

  List<UserAchievement> get userAchievements => _userAchievements;

  final String apiUrl = Urls.getLoggedUserAchievements;

  Future<void> fetchUserAchievements() async {
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
        _userAchievements = data.map((achievement) => UserAchievement.fromJson(achievement)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load logged users achievements');
      }
    } catch (error) {
      rethrow;
    }
  }
}
