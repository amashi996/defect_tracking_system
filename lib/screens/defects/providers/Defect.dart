import 'package:flutter/material.dart';

class Defect {
  final String id;
  final String projectTitle;
  final String defectTitle;
  final String defectDescription;
  final String defectStatus;
  final String defectPriority;
  final String defectSeverity;
  final String reportedBy;
  final String assignedTo;
  final DateTime createdDate;
  final DateTime? resolvedDate;
  final DateTime? closedDate;
  final DateTime modifiedDate;
  final String reproduceSteps;
  final String expectedResult;
  final String actualResult;

  Defect({
    required this.id,
    required this.projectTitle,
    required this.defectTitle,
    required this.defectDescription,
    required this.defectStatus,
    required this.defectPriority,
    required this.defectSeverity,
    required this.reportedBy,
    required this.assignedTo,
    required this.createdDate,
    this.resolvedDate,
    this.closedDate,
    required this.modifiedDate,
    required this.reproduceSteps,
    required this.expectedResult,
    required this.actualResult,
  });
}

class DefectProvider with ChangeNotifier {
  List<Defect> _defects = [];
  bool _isLoading = false;

  List<Defect> get defects => _defects;
  bool get isLoading => _isLoading;

  void fetchDefects() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    // Example data
    _defects = [
      Defect(
        id: '1',
        projectTitle: 'Project A',
        defectTitle: 'Defect 1',
        defectDescription: 'Description of Defect 1',
        defectStatus: 'New',
        defectPriority: 'High',
        defectSeverity: 'Critical',
        reportedBy: 'User 1',
        assignedTo: 'User 2',
        createdDate: DateTime.now(),
        modifiedDate: DateTime.now(),
        reproduceSteps: 'Steps to reproduce defect 1',
        expectedResult: 'Expected result of defect 1',
        actualResult: 'Actual result of defect 1',
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
