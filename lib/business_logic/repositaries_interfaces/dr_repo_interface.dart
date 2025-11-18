import '../../data/models/doctor_model.dart';

abstract class DoctorRepositoryInterface {
  Future<Doctor> getDoctorById(String id);
  Future<List<Doctor>> getDoctors();
}