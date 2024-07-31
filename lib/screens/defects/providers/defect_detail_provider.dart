import 'dart:convert';

import 'package:defect_tracking_system/constants/urls/urls.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Attachment {
  String fileName;
  String mimetype;
  int size;
  String url;

  Attachment({
    required this.fileName,
    required this.mimetype,
    required this.size,
    required this.url,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      fileName: json['fileName'] ?? '',
      mimetype: json['mimetype'] ?? '',
      size: json['size'] ?? 0,
      url: json['url'] ?? '',
    );
  }
}

class Comment {
  String user;
  String defectComment;
  DateTime commentDate;
  List<Attachment> commentAttachment;

  Comment({
    required this.user,
    required this.defectComment,
    required this.commentDate,
    required this.commentAttachment,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    var attachments = json['commentAttachment'] as List? ?? [];
    List<Attachment> attachmentList =
        attachments.map((i) => Attachment.fromJson(i)).toList();

    return Comment(
      user: json['user'] ?? '',
      defectComment: json['defectComment'] ?? '',
      commentDate: json['commentDate'] != null
          ? DateTime.parse(json['commentDate'])
          : DateTime.now(),
      commentAttachment: attachmentList,
    );
  }
}

class DefectDetail {
  String defectTitle;
  String defectDescription;
  String defectStatus;
  String defectPriority;
  String defectSeverity;
  String reproduceSteps;
  String expectedResult;
  String actualResult;
  String assignee;
  String reporter;
  DateTime createdDate;
  DateTime? resolvedDate;
  DateTime? closedDate;
  DateTime modifiedDate;
  List<Attachment> defectAttachment;
  List<Comment> defectComment;
  String id;

  DefectDetail({
    required this.id,
    required this.defectTitle,
    required this.defectDescription,
    required this.defectStatus,
    required this.defectPriority,
    required this.defectSeverity,
    required this.reproduceSteps,
    required this.expectedResult,
    required this.actualResult,
    required this.assignee,
    required this.reporter,
    required this.createdDate,
    this.resolvedDate,
    this.closedDate,
    required this.modifiedDate,
    required this.defectAttachment,
    required this.defectComment,
  });

  factory DefectDetail.fromJson(Map<String, dynamic> json) {
    var attachments = json['defectAttachment'] as List? ?? [];
    List<Attachment> attachmentList =
        attachments.map((i) => Attachment.fromJson(i)).toList();

    var comments = json['defectComment'] as List? ?? [];
    List<Comment> commentList =
        comments.map((i) => Comment.fromJson(i)).toList();

    return DefectDetail(
      id: json['_id'] ?? '',
      defectTitle: json['defectTitle'] ?? '',
      defectDescription: json['defectDescription'] ?? '',
      defectStatus: json['defectStatus'] ?? '',
      defectPriority: json['defectPriority'] ?? '',
      defectSeverity: json['defectSeverity'] ?? '',
      reproduceSteps: json['reproduceSteps'] ?? '',
      expectedResult: json['expectedResult'] ?? '',
      actualResult: json['actualResult'] ?? '',
      assignee: json['assignee'] ?? '',
      reporter: json['reporter'] ?? '',
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : DateTime.now(),
      resolvedDate: json['resolvedDate'] != null
          ? DateTime.parse(json['resolvedDate'])
          : null,
      closedDate: json['closedDate'] != null
          ? DateTime.parse(json['closedDate'])
          : null,
      modifiedDate: json['modifiedDate'] != null
          ? DateTime.parse(json['modifiedDate'])
          : DateTime.now(),
      defectAttachment: attachmentList,
      defectComment: commentList,
    );
  }
}

class User {
  final String id;
  final String name;
  final String avatar;

  User({
    required this.avatar,
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['_id'], name: json['name'], avatar: json['avatar']);
  }
}

class DefectDetailProvider with ChangeNotifier {
  DefectDetail _defect = DefectDetail(
    id: '',
    defectTitle: '',
    defectDescription: '',
    defectStatus: 'New',
    defectPriority: 'High',
    defectSeverity: 'Critical',
    reproduceSteps: '',
    expectedResult: '',
    actualResult: '',
    assignee: '',
    reporter: '',
    createdDate: DateTime.now(),
    modifiedDate: DateTime.now(),
    defectAttachment: [],
    defectComment: [],
  );

  DefectDetail? _selectedDefect;

  DefectDetail? get defect => _selectedDefect;
  final Map<String, User> _userCache = {};

  Future<void> fetchUserDetails(String userId) async {
    if (_userCache.containsKey(userId)) {
      return;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    final response = await http.get(
      Uri.parse(Urls.getSingleUserDetails + userId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-auth-token': token!,
      },
    );

    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));
      _userCache[userId] = user;
      notifyListeners();
    } else {
      throw Exception('Failed to load user details');
    }
  }

  User? getUser(String userId) {
    return _userCache[userId];
  }

  Future<void> fetchDefectDetails(String defectId) async {
    await Future.delayed(const Duration(seconds: 2));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    final response = await http.get(
      Uri.parse(Urls.getSingleDefectDetail + defectId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-auth-token': token!
      },
    );

    if (response.statusCode == 200) {
      _selectedDefect = DefectDetail.fromJson(jsonDecode(response.body));
      await fetchUserDetails(_selectedDefect!.assignee);
      await fetchUserDetails(_selectedDefect!.reporter);
      notifyListeners();
    } else {
      throw Exception('Failed to load review details');
    }
  }

  void updateDefect(DefectDetail newDefect) {
    _defect = newDefect;
    notifyListeners();
  }

  void addComment(Comment comment) {
    _defect.defectComment.add(comment);
    notifyListeners();
  }

  void addAttachment(Attachment attachment) {
    _defect.defectAttachment.add(attachment);
    notifyListeners();
  }
}
