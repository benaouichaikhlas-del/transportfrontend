class UserModel {
  final int id;
  final String email;
  final String role;
  final String token;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['user']['id'],
    email: json['user']['email'],
    role: json['user']['role'],
    token: json['token'],
  );
}
