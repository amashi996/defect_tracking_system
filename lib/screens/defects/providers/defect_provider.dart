import 'dart:convert';
import 'package:defect_tracking_system/constants/urls/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Defect {
  final String id;
  //final String projectTitle;
  final String defectTitle;
  final String defectStatus;
  final String assignedTo;
  //final DateTime createdDate;
  

  Defect({
    required this.id,
    //required this.projectTitle,
    required this.defectTitle,
    required this.defectStatus,
    required this.assignedTo,
    //required this.createdDate,
  });

  factory Defect.fromJson(Map<String, dynamic> json) {
    return Defect(
      id: json['_id'],
      //projectTitle: json['projectTitle'],
      defectTitle: json['defectTitle'],
      defectStatus: json['defectStatus'],
      assignedTo: json['assignedTo'],
      //createdDate: DateTime.parse(json['createdDate']),
    );
  }
}

class DefectsProvider with ChangeNotifier {
  List<Defect> _defects = [];
  bool _isLoading = false;

  List<Defect> get defects => _defects;
  bool get isLoading => _isLoading;

  final String apiUrl = Urls.getAllDefects;

  Future<void> fetchDefects() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    
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
        List<dynamic> defectsList = jsonDecode(response.body);
        _defects =
            defectsList.map((json) => Defect.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load defects');
      }
    } catch (error) {
      throw Exception('Failed to load defects: $error');
    }
  }
}
