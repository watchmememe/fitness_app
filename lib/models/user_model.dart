class UserModel {
  final String name;
  final int age;
  final int height;
  final int weight;
  final String program;
  final String profileImage;

  UserModel({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.program,
    required this.profileImage,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      height: map['height'] ?? 0,
      weight: map['weight'] ?? 0,
      program: map['program'] ?? '',
      profileImage: map['profileImage'] ?? '',
    );
  }
}
