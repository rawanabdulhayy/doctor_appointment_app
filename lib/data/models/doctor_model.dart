import 'package:equatable/equatable.dart';

class Doctor extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String gender;
  final String address;
  final String description;
  final String degree;
  final Specialization specialization;
  final City city;
  final double appointPrice;
  final String startTime;
  final String endTime;

  const Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.gender,
    required this.address,
    required this.description,
    required this.degree,
    required this.specialization,
    required this.city,
    required this.appointPrice,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object> get props => [
    id,
    name,
    email,
    phone,
    photo,
    gender,
    address,
    description,
    degree,
    specialization,
    city,
    appointPrice,
    startTime,
    endTime,
  ];

  // json here is of type Map<String, dynamic> because we already use dio, which decodes the json strings into a map structure automatically.
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photo: json['photo'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      degree: json['degree'] ?? '',
      specialization: Specialization.fromJson(json['specialization'] ?? {}),
      city: City.fromJson(json['city'] ?? {}),
      appointPrice: (json['appoint_price'] ?? 0.0).toDouble(),
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'gender': gender,
      'address': address,
      'description': description,
      'degree': degree,
      'specialization': specialization.toJson(),
      'city': city.toJson(),
      'appoint_price': appointPrice,
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  // copyWith method
  Doctor copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? photo,
    String? gender,
    String? address,
    String? description,
    String? degree,
    Specialization? specialization,
    City? city,
    double? appointPrice,
    String? startTime,
    String? endTime,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      description: description ?? this.description,
      degree: degree ?? this.degree,
      specialization: specialization ?? this.specialization,
      city: city ?? this.city,
      appointPrice: appointPrice ?? this.appointPrice,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  // Helper getters for compatibility with existing UI
  String get speciality => specialization.name;
  String get university => '${city.name}, ${city.governrate.name}';
  String get aboutMe => description;
  String get workingTime => '$startTime - $endTime';
  String get str => degree;
  String get practiceExperience => '${specialization.name} Specialist';
  String get practiceYears => 'Experienced ${specialization.name} Doctor';

  // Default values for rating and reviews
  double get rating => 4.5;
  int get reviewsNumber => 125;
}

class Specialization extends Equatable {
  final int id;
  final String name;

  const Specialization({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  Specialization copyWith({
    int? id,
    String? name,
  }) {
    return Specialization(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class City extends Equatable {
  final int id;
  final String name;
  final Governrate governrate;

  const City({
    required this.id,
    required this.name,
    required this.governrate,
  });

  @override
  List<Object> get props => [id, name, governrate];

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      governrate: Governrate.fromJson(json['governrate'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'governrate': governrate.toJson(),
    };
  }

  City copyWith({
    int? id,
    String? name,
    Governrate? governrate,
  }) {
    return City(
      id: id ?? this.id,
      name: name ?? this.name,
      governrate: governrate ?? this.governrate,
    );
  }
}

class Governrate extends Equatable {
  final int id;
  final String name;

  const Governrate({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];

  factory Governrate.fromJson(Map<String, dynamic> json) {
    return Governrate(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  Governrate copyWith({
    int? id,
    String? name,
  }) {
    return Governrate(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}