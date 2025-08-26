class UserModel {
  final int? id;
  final String username;
  final String password;
  final String role; // admin, seller, buyer

  UserModel({
    this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'username': username,
    'password': password,
    'role': role,
  };

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
    id: m['id'] as int?,
    username: m['username'] as String,
    password: m['password'] as String,
    role: m['role'] as String,
  );
}
