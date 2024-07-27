import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:defect_tracking_system/screens/profile/models/achievement_model.dart';
import 'package:defect_tracking_system/constants/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementProvider with ChangeNotifier {
  List<Achievement> _achievements = [];
  
  List<Achievement> get achievements => _achievements;
  
  final String apiUrl = Urls.getAllAchievements;
  
  Future<void> fetchAchievements() async {
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
        final List<dynamic> achievementList = json.decode(response.body);
        _achievements = achievementList.map((data) => Achievement.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load achievements');
      }
    } catch (error) {
      throw Exception('Failed to load achievements: $error');
    }
    
  }
}

