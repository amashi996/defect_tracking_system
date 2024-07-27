// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:defect_tracking_system/screens/profile/models/badge_model.dart';
import 'package:defect_tracking_system/constants/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgeProvider with ChangeNotifier {
  List<AllBadge> _badges = [];

  List<AllBadge> get badges => _badges;

  final String apiUrl = Urls.getAllBadges;

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
        print('Response body: ${response.body}'); // Log response body
        final List<dynamic> badgeList = json.decode(response.body);
        _badges = badgeList.map((data) => AllBadge.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load badges');
      }
    } catch (error) {
      throw Exception('Failed to load badges: $error');
    }
    
  }
}
