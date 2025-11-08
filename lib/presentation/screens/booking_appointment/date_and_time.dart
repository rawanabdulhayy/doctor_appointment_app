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

class DateAndTime extends StatelessWidget {
  const DateAndTime({super.key});

  @override
  Widget build(BuildContext context) {
    final timeSlots = TimeSlotHelper.customTimeSlots();

    //todo: we wanna have a double tap to cancel?
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
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
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      ).then((pickedDate) {
                        if (pickedDate != null) {
                          context.read<BookingBloc>().add(
                            UpdateDateTimeEvent(
                              pickedDate,
                              state.selectedTime ?? '',
                            ),
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
                visibleDates: 5, // Number of dates to scroll per arrow click
                selectedDate: state.selectedDate,
                onDateSelected: (date) {
                  context.read<BookingBloc>().add(
                    UpdateDateTimeEvent(date, state.selectedTime ?? ''),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Available time',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Time Slots Grid
              TimeSlotSelector(
                selectedTime: state.selectedTime,
                timeSlots: timeSlots,
                onTimeSelected: (time) {
                  context.read<BookingBloc>().add(
                    UpdateDateTimeEvent(
                      //already stored in picked date
                      state.selectedDate ?? DateTime.now(),
                      time,
                    ),
                  );
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
                  onPressed:
                      state.selectedDate != null && state.selectedTime != null && state.appointmentType != null
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
