import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id; //nullable for new users, provided by the api.
  final String? name;
  final String email;
  final String phone;
  final String? gender;

  const User({
    this.id,
    this.name,
    required this.email,
    required this.phone,
    this.gender,
  });

  @override
  List<Object?> get props => [id, name, email, phone, gender];

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     id: json['id'] is int ? json['id'] : null,
  //     name: json['name'] ?? _extractNameFromEmail(json['email']),
  //     email: json['email'] ?? '',
  //     phone: json['phone'] ?? '',
  //     gender: _parseGender(json['gender']), // Parse both int and string
  //   );
  // }
  factory User.fromJson(dynamic json) {
    print('🔍 User.fromJson received type: ${json.runtimeType}');
    print('🔍 User.fromJson received value: $json');

    // Add safety check
    if (json is! Map<String, dynamic>) {
      throw FormatException(
          'User.fromJson expects Map<String, dynamic> but got ${json.runtimeType}'
      );
    }

    return User(
      id: json['id'],
      name: json['name'] ?? json['username'] ?? _extractNameFromEmail(json['email']),      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: _parseGender(json['gender']),
    );
  }
  static String? _parseGender(dynamic gender) {
    if (gender == null) return null;
    if (gender is String) return gender;
    if (gender is int) {
      return gender == 1 ? 'male' : 'female';
    }
    return gender.toString();
  }

  static String _extractNameFromEmail(String? email) {
    if (email == null || email.isEmpty) return 'User';
    return email.split('@').first;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': genderForApi,
    };
  }

  int? get genderForApi {
    if (gender == null) return null;
    if (gender == 'male' || gender == '1') return 1;
    if (gender == 'female' || gender == '2') return 2;
    return null;
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
      gender: gender ?? this.gender.toString(),
    );
  }
}
