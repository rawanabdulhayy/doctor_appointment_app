import 'package:equatable/equatable.dart';

class Doctor extends Equatable {
  final String id;
  final String image;
  final String name;
  final String speciality;
  final double rating;
  final int reviewsNumber;
  final String university;

  const Doctor({
    required this.id,
    required this.image,
    required this.name,
    required this.speciality,
    required this.rating,
    required this.reviewsNumber,
    required this.university,
  });

  @override
  List<Object> get props => [
    id,
    image,
    name,
    speciality,
    rating,
    reviewsNumber,
    university,
  ];

  // For easy conversion from my existing Map structure? what's my map structure here?
  // why do we need a fromMap sometimes, others we need a fromJson despite the fact that a json is actually a Map<String, dynamic>? and when do we need both?
  // what does a factory constructor do? what are flutter's different types of constructors and what are their useCases?
  factory Doctor.fromMap(Map<String, dynamic> map, String id) {
    return Doctor(
      id: id,
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      speciality: map['speciality'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewsNumber: map['reviewsNumber'] ?? 0,
      university: map['university'] ?? '',
    );
  }
}