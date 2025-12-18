//todo: why are we using a copyWith method in here?
import '../../../data/models/doctor_model.dart';

class BookingState {
  final int currentIndex;

  final DateTime? selectedDate;
  final String? selectedTime;
  final String? appointmentType;

  final String? paymentMethod;
  final String? creditCardType;

  final bool isSubmitting;
  final bool isSubmitted;
  final String? errorMessage;

  final Doctor doctor;
  final String? bookingId;
  final bool isLoadingSlots;
  final List<String> bookedSlots;

  BookingState({
    required this.doctor,
    required this.currentIndex,
    this.selectedDate,
    this.selectedTime,
    this.appointmentType,
    this.paymentMethod,
    this.creditCardType,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.bookingId,
    this.errorMessage,
    this.isLoadingSlots = false,
    this.bookedSlots = const [],
  });

  // Factory constructor for initial state
  factory BookingState.initial({required Doctor doctor}) {
    return BookingState(
      doctor: doctor,
      currentIndex: 0,
      selectedDate: null,
      selectedTime: null,
      appointmentType: null,
      paymentMethod: null,
      creditCardType: null,
      isSubmitting: false,
      isSubmitted: false,
      bookingId: null,
      errorMessage: null,
      isLoadingSlots: false,
      bookedSlots: const [],
    );
  }

  BookingState copyWith({
    Doctor? doctor,
    int? currentIndex,
    DateTime? selectedDate,
    String? selectedTime,
    String? appointmentType,
    String? paymentMethod,
    String? creditCardType,
    bool? isSubmitting,
    bool? isSubmitted,
    String? bookingId,
    String? errorMessage,
    bool? isLoadingSlots,
    List<String>? bookedSlots,
  }) {
    return BookingState(
      doctor: doctor ?? this.doctor,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      appointmentType: appointmentType ?? this.appointmentType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      creditCardType: creditCardType ?? this.creditCardType,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      bookingId: bookingId ?? this.bookingId,
      errorMessage: errorMessage,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      bookedSlots: bookedSlots ?? this.bookedSlots,
    );
  }
}
