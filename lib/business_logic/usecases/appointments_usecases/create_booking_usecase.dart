import '../../repositaries_interfaces/booking_repo_interface.dart';

class CreateBookingUseCase {
  final BookingRepositoryInterface repository;

  CreateBookingUseCase(this.repository);

  Future<String> call({
    required int doctorId,
    required String startTime,
  }) async {
    return await repository.createBooking(
      doctorId: doctorId,
      startTime: startTime,
    );
  }
}