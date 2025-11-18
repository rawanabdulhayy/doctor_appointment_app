import '../../data/models/doctor_model.dart';
import '../repositaries_interfaces/dr_repo_interface.dart';

class GetDoctorByIdUseCase {
  final DoctorRepositoryInterface repository;

  GetDoctorByIdUseCase(this.repository);

  Future<Doctor> call(String id) {
    return repository.getDoctorById(id);
  }
}