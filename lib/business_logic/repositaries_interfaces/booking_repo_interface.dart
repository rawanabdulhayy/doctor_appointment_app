import '../../data/models/appointment_model.dart';

abstract class BookingRepositoryInterface {
  Future<List<String>> getBookedSlots({
    required int doctorId,
    required DateTime date,
  });

  Future<String> createBooking({
    required int doctorId,
    required String startTime,
  });

  Future<List<Appointment>> getUserAppointments();
}