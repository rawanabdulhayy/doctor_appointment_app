import '../../data/models/doctor_model.dart';

abstract class DoctorRepositoryInterface {
  Future<Doctor> getDoctorById(String id);
  Future<List<Doctor>> getDoctors();
  Future<List<Doctor>> getFilteredDoctors({
    String searchQuery = '',
    int? specializationId,
    int? cityId,
  });
  Future<List<Specialization>> getSpecializations();
  Future<List<City>> getCities();
}