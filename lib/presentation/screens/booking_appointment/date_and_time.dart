import 'package:doctor_appointment_app/presentation/widgets/booking_appointment_progress_bar.dart';
import 'package:flutter/material.dart';

class DateAndTime extends StatelessWidget {
  const DateAndTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BookingAppointmentProgressBar(),
        ],
      ),
    );
  }
}
