import 'package:doctor_appointment_app/business_logic/state_management/booking_appointment_bloc/booking_appointment_bloc.dart';
import 'package:doctor_appointment_app/business_logic/state_management/booking_appointment_bloc/booking_appointment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingAppointmentProgressBar extends StatelessWidget {
  const BookingAppointmentProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    //Why was the two formula using division by two? why two?

    // index	index.isOdd	index ~/ 2	Meaning
    // 0	false	0	Step 0
    // 1	true	0	Divider after step 0
    // 2	false	1	Step 1
    // 3	true	1	Divider after step 1
    // 4	false	2	Step 2

    // So each divider (odd index) "belongs" to the previous step — that’s why dividing by two helps you figure out which step it connects from.

    // Why not divide by something else?
    // If you divided by 3 or any other number, the mapping between even/odd indices and steps would break.
    // Since you’ve got a repeating pattern of step, divider, step, divider, step, the index alternates every 1 item — and each pair (step + divider) corresponds to one step index. That’s why dividing by 2 works perfectly.
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final steps = ['Date & Time', 'Payment', 'Summary'];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
          child: Row(
            //this returns the number of steps containers and dividers in between except for the last divider
            children: List.generate(steps.length * 2 - 1, (index) {
              //Creates a list with length positions and fills it with values created by calling generator for each index in the range 0 .. length - 1 in increasing order.
              if (index.isOdd) {
                // Divider between steps
                return Expanded(
                  //so we should use a container instead of a divider if we are gonna be using it inside a row, because dividers only ever work in columns.
                  //rows however, they can use the VerticalDividers
                  child: Container(
                    height: 2,
                    // This operator performs division and then rounds the result towards zero, effectively discarding any fractional part.
                    //e.g. in page of index 1 -- payment, first divider of index 1 (odd) >> 1 > 1/2 >> green.
                    //e.g. in page of index 0 -- date and time, first divider of index 1 (odd) >> 0 < 1/2 >> grey >> not yet passed to next screen.
                    color: state.currentIndex > (index ~/ 2)
                        ? Colors.green
                        : Colors.grey[300],
                  ),
                );
              } else {
                //even index >> actual containers
                final stepIndex = index ~/ 2;
                // first container (0) >> stepIndex 0/2 = 0

                // first page (0)
                // 0 == 0 >> current >> blue

                //second page (1)
                // 0 < 1 >> passed >> green
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
                          //indices start from 0.
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
