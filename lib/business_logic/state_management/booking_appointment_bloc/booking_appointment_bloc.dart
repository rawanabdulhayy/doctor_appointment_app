import 'package:doctor_appointment_app/business_logic/repositaries_interfaces/booking_repo_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../data/models/doctor_model.dart';
import 'booking_appointment_event.dart';
import 'booking_appointment_state.dart';
//todo: The BookingBloc needs doctor-specific data integration.
//
// Accept doctor data on initialization
// Handle available time slots from the doctor's schedule
// Manage booked appointments to dim reserved slots
// Submit complete booking data

// Single Responsibility: DoctorBloc handles doctor discovery (listing, filtering, search), while BookingBloc handles the appointment booking flow
// Different Data Sources: Doctor info comes from doctor endpoints, appointments from booking endpoints
// Independent Lifecycles: DoctorBloc lives throughout app navigation, BookingBloc lives only during the booking flow

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Doctor doctor;
  final BookingRepositoryInterface bookingRepository; // You'll need to create this

  // Cache of booked appointments for this doctor
  Map<DateTime, List<String>> _bookedSlots = {};

  // We can also pass the initial current index to the constructor without having a named factory initial constructor:
  // BookingBloc() : super(BookingState(currentIndex: 0))
  // But this approach is cleaner
  BookingBloc({
    required this.doctor,
    required this.bookingRepository,
  }) : super(BookingState.initial(doctor: doctor))  {
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
    on<GoToPageEvent>(_onGoToPage);

    on<UpdateDateTimeEvent>(_onUpdateDateTime);
    on<UpdateAppointmentTypeEvent>(_onUpdateAppointmentType);

    on<UpdatePaymentEvent>(_onUpdatePayment);
    on<UpdateCreditCardEvent>(_onUpdateCreditCard);

    on<LoadAvailableSlotsEvent>(_onLoadAvailableSlots);
    on<SubmitBookingEvent>(_onSubmitBooking);
  }

  void _onNextPage(NextPageEvent event, Emitter<BookingState> emit) {
    if (state.currentIndex < 2) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void _onPreviousPage(PreviousPageEvent event, Emitter<BookingState> emit) {
    if (state.currentIndex > 0) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
    }
  }

  void _onGoToPage(GoToPageEvent event, Emitter<BookingState> emit) {
    if (event.pageIndex >= 0 && event.pageIndex <= 2) {
      emit(state.copyWith(currentIndex: event.pageIndex));
    }
  }

  void _onUpdateDateTime(
    UpdateDateTimeEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(selectedDate: event.date, selectedTime: event.time));
  }

  void _onUpdateAppointmentType(
    UpdateAppointmentTypeEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(appointmentType: event.appointmentType));
  }

  void _onUpdatePayment(UpdatePaymentEvent event, Emitter<BookingState> emit) {
    emit(
      state.copyWith(
        paymentMethod: event.paymentMethod,
        // if user switches to something other than "Credit Card"
        // we clear any previously selected credit card
        creditCardType: event.paymentMethod == 'Credit Card'
            ? state.creditCardType
            : null,
      ),
    );
  }

  void _onUpdateCreditCard(
    UpdateCreditCardEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(creditCardType: event.creditCardType));
  }
  Future<void> _onLoadAvailableSlots(
      LoadAvailableSlotsEvent event,
      Emitter<BookingState> emit,
      ) async {
    emit(state.copyWith(isLoadingSlots: true));

    try {
      // Fetch booked appointments for this doctor on the selected date
      final bookedAppointments = await bookingRepository.getBookedSlots(
        doctorId: doctor.id,
        date: event.date,
      );

      // Store in cache
      _bookedSlots[_normalizeDate(event.date)] = bookedAppointments;

      emit(state.copyWith(
        isLoadingSlots: false,
        bookedSlots: bookedAppointments,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingSlots: false,
        errorMessage: 'Failed to load available slots: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSubmitBooking(
      SubmitBookingEvent event,
      Emitter<BookingState> emit,
      ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      // Format the start time as required by API: "2023-10-10 14:00"
      final startTime = _formatStartTimeForApi(
        state.selectedDate!,
        state.selectedTime!,
      );

      // Submit to API
      final bookingId = await bookingRepository.createBooking(
        doctorId: doctor.id,
        startTime: startTime,
      );

      emit(state.copyWith(
        isSubmitting: false,
        isSubmitted: true,
        bookingId: bookingId,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  // Helper method to calculate total with tax
  double _calculateTotalAmount() {
    final subtotal = doctor.appointPrice;
    final tax = subtotal * 0.05; // 5% tax example
    return subtotal + tax;
  }

  // Helper to normalize date (remove time component)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Helper to format time for API: "2023-10-10 14:00"
  // String _formatStartTimeForApi(DateTime date, String time) {
  //   // Parse time like "02:00 PM" or "2:00 PM"
  //   final timeParts = time.trim().split(' ');
  //   final hourMinute = timeParts[0].split(':');
  //   int hour = int.parse(hourMinute[0]);
  //   final minute = int.parse(hourMinute[1]);
  //
  //   // Handle AM/PM
  //   if (timeParts.length > 1) {
  //     final period = timeParts[1].toUpperCase();
  //     if (period == 'PM' && hour != 12) {
  //       hour += 12;
  //     } else if (period == 'AM' && hour == 12) {
  //       hour = 0;
  //     }
  //   }
  //
  //   // Format as "YYYY-MM-DD HH:MM"
  //   final dateStr = '${date.year.toString().padLeft(4, '0')}-'
  //       '${date.month.toString().padLeft(2, '0')}-'
  //       '${date.day.toString().padLeft(2, '0')}';
  //   final timeStr = '${hour.toString().padLeft(2, '0')}:'
  //       '${minute.toString().padLeft(2, '0')}';
  //
  //   return '$dateStr $timeStr';
  // }

  String _formatStartTimeForApi(DateTime date, String time) {
    debugPrint('=== DEBUG: Formatting Start Time for API ===');
    debugPrint('Date: $date');
    debugPrint('Time from selector: "$time"');

    // Make sure time is in correct 12-hour format
    // If it's something like "14:30 PM", convert it to "2:30 PM"
    String fixedTime = _fixTimeFormat(time);
    debugPrint('Fixed time: "$fixedTime"');

    // Format date as "Sunday, December 14, 2025"
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(date);
    final result = '$formattedDate $fixedTime';

    debugPrint('Final formatted: "$result"');
    return result;
  }

  String _fixTimeFormat(String time) {
    // If time is already in correct format (like "2:30 PM"), return as-is
    // Check if it has invalid format like "14:30 PM"

    final parts = time.trim().split(' ');
    if (parts.length != 2) return time; // No AM/PM, return as-is

    final timePart = parts[0]; // "14:30"
    final period = parts[1]; // "PM"

    final timeComponents = timePart.split(':');
    if (timeComponents.length != 2) return time;

    final hour = int.tryParse(timeComponents[0]);
    final minute = timeComponents[1];

    if (hour == null) return time;

    // If hour is 13-23 with "PM", convert to 12-hour
    if (hour >= 13 && hour <= 23 && period == 'PM') {
      final hour12 = hour - 12;
      return '$hour12:$minute $period';
    }

    // Otherwise return as-is
    return time;
  }
  // Public getter to check if a slot is booked
  bool isSlotBooked(DateTime date, String time) {
    final normalizedDate = _normalizeDate(date);
    final bookedTimes = _bookedSlots[normalizedDate] ?? [];
    return bookedTimes.contains(time);
  }
}
//Usage:
// // In DateAndTime widget
// ElevatedButton(
// onPressed: () {
// // Save date/time and navigate
// context.read<BookingBloc>().add(
// UpdateDateTimeEvent(selectedDate, selectedTime),
// );
// context.read<BookingBloc>().add(NextPageEvent());
// },
// child: Text('Next'),
// )
//
// // Back button
// IconButton(
// onPressed: () {
// context.read<BookingBloc>().add(PreviousPageEvent());
// },
// icon: Icon(Icons.arrow_back),
// )
//
// // In Summary widget
// ElevatedButton(
// onPressed: () {
// context.read<BookingBloc>().add(SubmitBookingEvent());
// },
// child: Text('Confirm Booking'),
// )

//Listen to State Changes (Optional)
// BlocListener<BookingBloc, BookingState>(
// listener: (context, state) {
// if (state.isSubmitted) {
// Navigator.pop(context);
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text('Booking confirmed!')),
// );
// }
// if (state.errorMessage != null) {
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text(state.errorMessage!)),
// );
// }
// },
// child: // your widget
// )
