import 'package:doctor_appointment_app/presentation/widgets/screen_wrapper/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_bloc.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_state.dart';
import '../../../business_logic/repositaries_interfaces/booking_repo_interface.dart';
import '../../../core/dependency_injection/injection_container.dart' as di;
import '../../../data/models/doctor_model.dart';
import '../../screens/booking_appointment/date_and_time.dart';
import '../../screens/booking_appointment/payment.dart';
import '../../screens/booking_appointment/summary.dart';

class ThreePageBookingAppointment extends StatelessWidget {
  final Doctor doctor;

  const ThreePageBookingAppointment({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc(
        doctor: doctor,
        bookingRepository: di.sl<BookingRepositoryInterface>(),
      ),
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

// Usage example - how to navigate to this screen from doctor details:
/*
// In your doctor details page or doctor card:
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThreePageBookingAppointment(
          doctor: doctor, // Pass the doctor object
        ),
      ),
    );
  },
  child: Text('Book Appointment'),
);
*/