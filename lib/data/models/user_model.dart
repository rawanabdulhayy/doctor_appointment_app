import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
  });

  @override
  List<Object?> get props => [id, name, email, phone, gender];

  factory User.fromJson(Map <String, dynamic> json){
    return User(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
    };
  }

  // copyWith method
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? gender,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
    );
  }
}
