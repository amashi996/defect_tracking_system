import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:defect_tracking_system/constants/urls/urls.dart';

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class UserDropdownProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse(Urls.getAllUsers));
    if (response.statusCode == 200) {
      List<dynamic> userList = jsonDecode(response.body);
      _users = userList.map((json) => User.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
