class AppUser {
  final int id;
  final String name;
  final String email;
  final String? role;
  final DateTime? createdAt;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'created_at': createdAt?.toIso8601String(),
      };
}
