// import 'package:doctor_appointment_app/presentation/widgets/date_and_time_page/booking_appointment_progress_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_bloc.dart';
// import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_event.dart';
// import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_state.dart';
// import '../../../core/helper_widgets/time_slot_helper.dart';
// import '../../widgets/date_and_time_page/appointment_type_selector.dart';
// import '../../widgets/date_and_time_page/bi_directional_date_selector.dart';
// import '../../widgets/date_and_time_page/time_slot_selector.dart';
//
// class DateAndTime extends StatelessWidget {
//   const DateAndTime({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final timeSlots = TimeSlotHelper.customTimeSlots();
//
//     //todo: we wanna have a double tap to cancel?
//     return BlocBuilder<BookingBloc, BookingState>(
//       builder: (context, state) {
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               BookingAppointmentProgressBar(),
//               // Date Selector Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Select Date',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       // Show calendar picker
//                       showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime.now().add(Duration(days: 365)),
//                       ).then((pickedDate) {
//                         if (pickedDate != null) {
//                           context.read<BookingBloc>().add(
//                             UpdateDateTimeEvent(
//                               pickedDate,
//                               state.selectedTime ?? '',
//                             ),
//                           );
//                         }
//                       });
//                     },
//                     child: Text('Set Manual'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Date Carousel
//               BidirectionalDateSelector(
//                 visibleDates: 5, // Number of dates to scroll per arrow click
//                 selectedDate: state.selectedDate,
//                 onDateSelected: (date) {
//                   context.read<BookingBloc>().add(
//                     UpdateDateTimeEvent(date, state.selectedTime ?? ''),
//                   );
//                 },
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Available time',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//
//               // Time Slots Grid
//               TimeSlotSelector(
//                 selectedTime: state.selectedTime,
//                 timeSlots: timeSlots,
//                 onTimeSelected: (time) {
//                   context.read<BookingBloc>().add(
//                     UpdateDateTimeEvent(
//                       //already stored in picked date
//                       state.selectedDate ?? DateTime.now(),
//                       time,
//                     ),
//                   );
//                 },
//               ),
//
//               const SizedBox(height: 24),
//               Text(
//                 'Appointment Type',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               AppointmentTypeSelector(),
//
//               const SizedBox(height: 32),
//               // Continue Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed:
//                       state.selectedDate != null && state.selectedTime != null && state.appointmentType != null
//                       ? () {
//                           context.read<BookingBloc>().add(NextPageEvent());
//                         }
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2E7CF6),
//                     disabledBackgroundColor: Colors.grey[300],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     'Continue',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:doctor_appointment_app/presentation/widgets/date_and_time_page/booking_appointment_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_bloc.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_event.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_state.dart';
import '../../../core/helper_widgets/time_slot_helper.dart';
import '../../widgets/date_and_time_page/appointment_type_selector.dart';
import '../../widgets/date_and_time_page/bi_directional_date_selector.dart';
import '../../widgets/date_and_time_page/time_slot_selector.dart';

class DateAndTime extends StatefulWidget {
  const DateAndTime({super.key});

  @override
  State<DateAndTime> createState() => _DateAndTimeState();
}

class _DateAndTimeState extends State<DateAndTime> {
  @override
  void initState() {
    super.initState();
    // Load booked slots for today when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<BookingBloc>();
      if (bloc.state.selectedDate != null) {
        bloc.add(LoadAvailableSlotsEvent(bloc.state.selectedDate!));
      } else {
        // Load for today if no date selected
        bloc.add(LoadAvailableSlotsEvent(DateTime.now()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Generate time slots from doctor's working hours
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final timeSlots = TimeSlotHelper.generateSlotsFromRange(
          state.doctor.startTime,
          state.doctor.endTime,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingAppointmentProgressBar(),
              // Date Selector Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Date',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // Show calendar picker
                      showDatePicker(
                        context: context,
                        initialDate: state.selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      ).then((pickedDate) {
                        if (pickedDate != null) {
                          // Update date and load booked slots
                          context.read<BookingBloc>().add(
                            UpdateDateTimeEvent(
                              pickedDate,
                              state.selectedTime ?? '',
                            ),
                          );
                          context.read<BookingBloc>().add(
                            LoadAvailableSlotsEvent(pickedDate),
                          );
                        }
                      });
                    },
                    child: Text('Set Manual'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date Carousel
              BidirectionalDateSelector(
                visibleDates: 5,
                selectedDate: state.selectedDate,
                onDateSelected: (date) {
                  // Update date and load booked slots
                  context.read<BookingBloc>().add(
                    UpdateDateTimeEvent(date, state.selectedTime ?? ''),
                  );
                  context.read<BookingBloc>().add(
                    LoadAvailableSlotsEvent(date),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Available time header with loading indicator
              Row(
                children: [
                  Text(
                    'Available time',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (state.isLoadingSlots) ...[
                    const SizedBox(width: 12),
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // Time Slots Grid
              TimeSlotSelector(
                selectedTime: state.selectedTime,
                timeSlots: timeSlots,
                bookedSlots: state.bookedSlots, // Pass booked slots
                selectedDate: state.selectedDate, // Add this
                onTimeSelected: (time) {
                  // Check if the slot is booked
                  if (!state.bookedSlots.contains(time)) {
                    context.read<BookingBloc>().add(
                      UpdateDateTimeEvent(
                        state.selectedDate ?? DateTime.now(),
                        time,
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 24),
              Text(
                'Appointment Type',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              AppointmentTypeSelector(),

              const SizedBox(height: 32),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: state.selectedDate != null &&
                      state.selectedTime != null &&
                      state.appointmentType != null &&
                      !state.isLoadingSlots
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