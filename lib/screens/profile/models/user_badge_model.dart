class UserBadge {
  final String id;
  final String name;
  final String description;
  final String icon;

  UserBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}
