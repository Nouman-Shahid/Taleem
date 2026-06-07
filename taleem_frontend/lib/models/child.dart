class Child {
  final int id;
  final String name;
  final int age;
  final String gender;
  final String? avatar;

  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.avatar,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'] as int,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'avatar': avatar,
      };
}
