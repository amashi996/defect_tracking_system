import 'dart:convert';
import 'package:defect_tracking_system/constants/urls/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// leaderboard_entry.dart

class LeaderBoard {
  final String name;
  final String avatar;
  final String email;
  final double totalPoints;
  final String id;

  LeaderBoard({
    required this.name,
    required this.avatar,
    required this.email,
    required this.totalPoints,
    required this.id,
  });

  factory LeaderBoard.fromJson(Map<String, dynamic> json) {
    return LeaderBoard(
        name: json['name'],
        avatar: json['avatar'],
        email: json['email'],
        totalPoints: json['totalPoints'],
        id: json['_id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'email': email,
      'totalPoints': totalPoints,
      '_id': id
    };
  }
}

class LeaderboardProvider with ChangeNotifier {
  List<LeaderBoard> _leaderboard = [];

  List<LeaderBoard> get leaderboard => _leaderboard;

  final String apiUrl = Urls.getLeaderBoard;
  
  Future<void> fetchLeaderboard() async {
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
        List<dynamic> leaderboardList = jsonDecode(response.body);
        _leaderboard =
            leaderboardList.map((json) => LeaderBoard.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load leaderboard');
      }
    } catch (error) {
      throw Exception('Failed to load leaderboard: $error');
    }
  }
}
