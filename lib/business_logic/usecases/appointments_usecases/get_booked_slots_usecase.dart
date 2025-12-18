import '../../repositaries_interfaces/booking_repo_interface.dart';

class GetBookedSlotsUseCase {
  final BookingRepositoryInterface repository;

  GetBookedSlotsUseCase(this.repository);

  Future<List<String>> call({
    required int doctorId,
    required DateTime date,
  }) async {
    return await repository.getBookedSlots(
      doctorId: doctorId,
      date: date,
    );
  }
}