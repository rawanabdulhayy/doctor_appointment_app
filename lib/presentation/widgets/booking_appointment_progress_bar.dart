import 'package:doctor_appointment_app/business_logic/state_management/booking_appointment_bloc/booking_appointment_bloc.dart';
import 'package:doctor_appointment_app/business_logic/state_management/booking_appointment_bloc/booking_appointment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingAppointmentProgressBar extends StatelessWidget {
  const BookingAppointmentProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final steps = [
          'Date & Time',
          'Payment',
          'Summary',
        ];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
          child: Row(
            //this returns the number of steps containers and dividers in between except for the last divider
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Divider between steps
                return Expanded(
                  child: Container(
                    height: 2,
                    color: state.currentIndex > (index ~/ 2)
                        ? Colors.green
                        : Colors.grey[300],
                  ),
                );
              } else {
                final stepIndex = index ~/ 2;
                final color = stepIndex == state.currentIndex
                    ? Colors.blue
                    : stepIndex < state.currentIndex
                    ? Colors.green
                    : Colors.grey;

                return Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                      child: Center(
                        child: Text(
                          '${stepIndex + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      steps[stepIndex],
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        );
      },
    );
  }
}
