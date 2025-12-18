import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NextPageEvent extends BookingEvent {}

class PreviousPageEvent extends BookingEvent {}

class GoToPageEvent extends BookingEvent {
  final int pageIndex;
  GoToPageEvent(this.pageIndex);
}

class UpdateDateTimeEvent extends BookingEvent {
  final DateTime date;
  final String time;
  UpdateDateTimeEvent(this.date, this.time);
}

class UpdateAppointmentTypeEvent extends BookingEvent {
  final String appointmentType;

  UpdateAppointmentTypeEvent(this.appointmentType);
}

class UpdatePaymentEvent extends BookingEvent {
  final String paymentMethod;
  UpdatePaymentEvent(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class UpdateCreditCardEvent extends BookingEvent {
  final String creditCardType;
  UpdateCreditCardEvent(this.creditCardType);

  @override
  List<Object?> get props => [creditCardType];
}

class LoadAvailableSlotsEvent extends BookingEvent {
  final DateTime date;

  LoadAvailableSlotsEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class SubmitBookingEvent extends BookingEvent {}

//what's being passed inside the event, is the one variable that should be passed in order to trigger the event.
