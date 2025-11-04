import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_bloc.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_event.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_state.dart';

class AppointmentTypeSelector extends StatelessWidget {
  const AppointmentTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentTypes = [
      {
        'label': 'In-Person',
        'icon': 'assets/images/date_and_time/f2f_icon.png',
      },
      {
        'label': 'Video Call',
        'icon': 'assets/images/date_and_time/video_call_icon.png',
      },
      {
        'label': 'Phone Call',
        'icon': 'assets/images/date_and_time/call_icon.png',
      },
    ];

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return RadioGroup<String>(
          groupValue: state.appointmentType, // Currently selected value
          onChanged: (value) {
            // When ANY radio is tapped
            if (value != null) {
              // Rebuilds the widget whenever state.appointmentType changes
              context.read<BookingBloc>().add(
                UpdateAppointmentTypeEvent(value),
              );
            }
          },
          child: Column(
            children: List.generate(appointmentTypes.length * 2 - 1, (index) {
              if (index.isOdd) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 17,
                  ),
                  child: Divider(
                    color: Colors.grey[200],
                    thickness: 1,
                    height: 10,
                  ),
                );
              }

              final typeIndex = index ~/ 2;
              final type = appointmentTypes[typeIndex];
              final isSelected = state.appointmentType == type['label']; //Checks if this option is currently selected


              return InkWell(
                onTap: () {
                  // Makes the entire row tappable (not just the radio button)
                  // Dispatches the same event to BLoC as the RadioGroup
                  context.read<BookingBloc>().add(
                    UpdateAppointmentTypeEvent(type['label']!),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Image.asset(
                        type['icon']!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(width: 10),

                      // Label
                      Expanded(
                        child: Text(
                          type['label']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.blue : Colors.black87,
                          ),
                        ),
                      ),

                      Radio<String>(
                        value: type['label']!,
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
// How Selection Works (Flow)
//
// User taps anywhere on a row (InkWell) or the radio button
// Event dispatched: UpdateAppointmentTypeEvent('Video Call')
// BLoC processes event: Updates state.appointmentType = 'Video Call'
// State emitted: New state with updated appointmentType
// BlocBuilder rebuilds: Widget rebuilds with new state
// RadioGroup updates: Radio button for 'Video Call' becomes selected
// Visual feedback:
//
// Radio button fills in
// Text turns blue (isSelected becomes true)
//
//
//
// Why Both InkWell AND RadioGroup?
//
// RadioGroup onChanged: Required by the new API, handles radio button taps
// InkWell onTap: Makes the entire row tappable for better UX (user can tap anywhere, not just the small radio circle)
//
// Both dispatch the same event, so tapping anywhere on the row selects that option!