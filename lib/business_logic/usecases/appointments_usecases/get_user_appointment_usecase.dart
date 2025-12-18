import '../../../data/models/appointment_model.dart';
import '../../repositaries_interfaces/booking_repo_interface.dart';

class GetUserAppointmentsUseCase {
  final BookingRepositoryInterface repository;

  GetUserAppointmentsUseCase(this.repository);

  Future<List<Appointment>> call() async {
    return await repository.getUserAppointments();
  }
}