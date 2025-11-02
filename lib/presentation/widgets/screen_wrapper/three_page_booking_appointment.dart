import 'package:doctor_appointment_app/presentation/widgets/screen_wrapper/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_bloc.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_state.dart';
import '../../screens/booking_appointment/date_and_time.dart';
import '../../screens/booking_appointment/payment.dart';
import '../../screens/booking_appointment/summary.dart';

class ThreePageBookingAppointment extends StatelessWidget {
  const ThreePageBookingAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc(),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          return ScreenWrapper(
            appBarTitle: 'Book Appointment',
            showNavBar: false,
            child: IndexedStack(
              index: state.currentIndex,
              children: const [
                DateAndTime(),
                Payment(),
                Summary(),
              ],
            ),
          );
        },
      ),
    );
  }
}