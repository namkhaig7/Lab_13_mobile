class AppUser {
  final int id;
  final String username;
  final String password;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;

  AppUser({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>? ?? {};
    return AppUser(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: name['firstname'] as String? ?? '',
      lastName: name['lastname'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  static List<AppUser> fromList(List<dynamic> data) {
    return data.map((e) => AppUser.fromJson(e as Map<String, dynamic>)).toList();
  }
}

