import 'dart:convert';

import 'package:defect_tracking_system/constants/urls/urls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String id;
  String name;
  String email;
  String password;
  String userRole;
  String username;
  String avatar;
  DateTime date;
  int sendingReviewPoints;
  int receivingReviewPoints;
  int totalPoints;
  List<Achievement> achievements;
  List<Badge> badges;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.userRole,
    required this.username,
    required this.avatar,
    required this.date,
    required this.sendingReviewPoints,
    required this.receivingReviewPoints,
    required this.totalPoints,
    required this.achievements,
    required this.badges,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      userRole: json['userRole'],
      username: json['username'],
      avatar: json['avatar'],
      date: DateTime.parse(json['date']),
      sendingReviewPoints: json['sendingReviewPoints'],
      receivingReviewPoints: json['receivingReviewPoints'],
      totalPoints: json['totalPoints'],
      achievements: (json['achievements'] as List)
          .map((e) => Achievement.fromJson(e))
          .toList(),
      badges: (json['badges'] as List).map((e) => Badge.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'userRole': userRole,
      'username': username,
      'avatar': avatar,
      'date': date.toIso8601String(),
      'sendingReviewPoints': sendingReviewPoints,
      'receivingReviewPoints': receivingReviewPoints,
      'totalPoints': totalPoints,
      'achievements': achievements.map((e) => e.toJson()).toList(),
      'badges': badges.map((e) => e.toJson()).toList(),
    };
  }
}

class Achievement {
  String achievementId;
  DateTime earnedDate;

  Achievement({required this.achievementId, required this.earnedDate});

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      achievementId: json['achievement_id'],
      earnedDate: DateTime.parse(json['earned_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'achievement_id': achievementId,
      'earned_date': earnedDate.toIso8601String(),
    };
  }
}

class Badge {
  String badgeId;
  DateTime earnedDate;

  Badge({required this.badgeId, required this.earnedDate});

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      badgeId: json['badge_id'],
      earnedDate: DateTime.parse(json['earned_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'badge_id': badgeId,
      'earned_date': earnedDate.toIso8601String(),
    };
  }
}

//provider code
// import 'dart:convert';
// import 'package:flutter/material.dart';

// import 'user_model.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    userRole: '',
    username: '',
    avatar: '',
    date: DateTime.now(),
    sendingReviewPoints: 0,
    receivingReviewPoints: 0,
    totalPoints: 0,
    achievements: [],
    badges: [],
  );
  User? get user => _user;

  Future<void> fetchUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    final response = await http.get(
      Uri.parse(
        Urls.getProfileDetails,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token!
      },
    );
    print('=======sss${response.body}');
    if (response.statusCode == 200) {
      _user = User.fromJson(jsonDecode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> updateUser(User user) async {
    final String apiUrl = 'http://your-api-url.com/users';
    final response = await http.put(
      Uri.parse('$apiUrl/${user.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      _user = user;
      notifyListeners();
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> createUser(User user) async {
    final String apiUrl = 'http://your-api-url.com/users';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      _user = User.fromJson(jsonDecode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to create user');
    }
  }
}
