class UserModel {
  final String uid;
  final String name;
  final int age;
  final double height; // in cm
  final double weight; // in kg

  UserModel({
    required this.uid,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      height: (data['height'] ?? 0).toDouble(),
      weight: (data['weight'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'age': age, 'height': height, 'weight': weight};
  }
}
