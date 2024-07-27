// models/achievement.dart

class Achievement {
  final String id;
  final String name;
  final String description;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class Badge {
  final String name;
  final String description;
  final String icon;

  Badge({
    required this.name,
    required this.description,
    required this.icon,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}
