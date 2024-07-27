class UserAchievement {
  final String id;
  final String name;
  final String description;
  final DateTime earnedDate;

  UserAchievement({
    required this.id,
    required this.name,
    required this.description,
    required this.earnedDate,
  });

  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    return UserAchievement(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      earnedDate: DateTime.parse(json['earned_date']),
    );
  }
}