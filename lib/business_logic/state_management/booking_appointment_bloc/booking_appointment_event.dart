abstract class BookingEvent {}

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

class UpdatePaymentEvent extends BookingEvent {
  final String paymentMethod;
  UpdatePaymentEvent(this.paymentMethod);
}

class SubmitBookingEvent extends BookingEvent {}

//what's being passed inside the event, is the one variable that should be passed in order to trigger the event.