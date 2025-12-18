import 'package:doctor_appointment_app/data/models/patient_model.dart';

import 'doctor_model.dart';

class Appointment {
  final int id;
  final Doctor doctor;
  final Patient patient;
  final String appointmentTime;
  final String appointmentEndTime;
  final String status;
  final String notes;
  final int appointmentPrice;

  Appointment({
    required this.id,
    required this.doctor,
    required this.patient,
    required this.appointmentTime,
    required this.appointmentEndTime,
    required this.status,
    required this.notes,
    required this.appointmentPrice,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as int,
      doctor: Doctor.fromJson(json['doctor']),
      patient: Patient.fromJson(json['patient']),
      appointmentTime: json['appointment_time'] as String,
      appointmentEndTime: json['appointment_end_time'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String? ?? '',
      appointmentPrice: json['appointment_price'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor': doctor.toJson(),
      'patient': patient.toJson(),
      'appointment_time': appointmentTime,
      'appointment_end_time': appointmentEndTime,
      'status': status,
      'notes': notes,
      'appointment_price': appointmentPrice,
    };
  }
}