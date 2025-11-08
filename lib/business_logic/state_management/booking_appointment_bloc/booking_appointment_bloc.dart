import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_appointment_event.dart';
import 'booking_appointment_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  // We can also pass the initial current index to the constructor without having a named factory initial constructor:
  // BookingBloc() : super(BookingState(currentIndex: 0))
  // But this approach is cleaner
  BookingBloc() : super(BookingState.initial()) {
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
    on<GoToPageEvent>(_onGoToPage);

    on<UpdateDateTimeEvent>(_onUpdateDateTime);
    on<UpdateAppointmentTypeEvent>(_onUpdateAppointmentType);

    on<UpdatePaymentEvent>(_onUpdatePayment);
    on<UpdateCreditCardEvent>(_onUpdateCreditCard);

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

  Future<void> _onSubmitBooking(
    SubmitBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      // Call your repository/API to submit booking
      // await bookingRepository.submitBooking(...);

      emit(state.copyWith(isSubmitting: false, isSubmitted: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
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
