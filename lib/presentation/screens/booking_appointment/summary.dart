import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_bloc.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_event.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_state.dart';
import '../../widgets/date_and_time_page/booking_appointment_progress_bar.dart';

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingAppointmentProgressBar(),
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                  state.selectedDate != null && state.selectedTime != null
                      ? () {
                    context.read<BookingBloc>().add(NextPageEvent());
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7CF6),
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
