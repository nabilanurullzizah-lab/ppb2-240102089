/// Model data mahasiswa, diambil dari endpoint /users (JSONPlaceholder).
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String company;
  final String city;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.company,
    required this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final company = json['company'] as Map<String, dynamic>?;
    final address = json['address'] as Map<String, dynamic>?;

    return User(
      id: json['id'] as int,
      name: json['name'] as String? ?? '-',
      username: json['username'] as String? ?? '-',
      email: json['email'] as String? ?? '-',
      phone: json['phone'] as String? ?? '-',
      company: company?['name'] as String? ?? '-',
      city: address?['city'] as String? ?? '-',
    );
  }
}
