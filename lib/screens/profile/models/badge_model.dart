class AllBadge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String iconAsset; // Use this for asset paths
  

  AllBadge({required this.id, required this.name, required this.description, required this.icon, required this.iconAsset,});

  /*factory AllBadge.fromJson(Map<String, dynamic> json) {
    return AllBadge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
    );
  }*/
  factory AllBadge.fromJson(Map<String, dynamic> json) {
  return AllBadge(
    id: json['id'] ?? '', // Provide default empty string if null
    name: json['name'] ?? '', // Provide default empty string if null
    description: json['description'] ?? '', // Provide default empty string if null
    icon: json['icon'] ?? '', // Provide default empty string if null
    iconAsset: json['iconAsset'] ?? '', // This should match with your database field
  );
}
}
