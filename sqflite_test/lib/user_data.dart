class UserData {
  UserData({
    required this.id,
    required this.name,
    required this.age,
  });
  int id = -1;
  String name = 'noname';
  int age = -1;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  @override
  String toString() => 'UserData{id: $id, name: $name, age: $age}';
}
