//todo: why are we using a copywith method in here?
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

  BookingState({
    required this.currentIndex,
    this.selectedDate,
    this.selectedTime,
    this.appointmentType,
    this.paymentMethod,
    this.creditCardType,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.errorMessage,
  });

  // Factory constructor for initial state
  factory BookingState.initial() {
    return BookingState(
      currentIndex: 0,
      selectedDate: null,
      selectedTime: null,
      appointmentType: null,
      paymentMethod: null,
      creditCardType: null,
      isSubmitting: false,
      isSubmitted: false,
      errorMessage: null,
    );
  }

  BookingState copyWith({
    int? currentIndex,
    DateTime? selectedDate,
    String? selectedTime,
    String? appointmentType,
    String? paymentMethod,
    String? creditCardType,
    bool? isSubmitting,
    bool? isSubmitted,
    String? errorMessage,
  }) {
    return BookingState(
      currentIndex: currentIndex ?? this.currentIndex,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      appointmentType: appointmentType ?? this.appointmentType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      creditCardType: creditCardType ?? this.creditCardType,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}