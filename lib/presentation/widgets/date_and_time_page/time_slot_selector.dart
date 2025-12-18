import 'package:doctor_appointment_app/core/helper_widgets/time_slot_helper.dart';
import 'package:flutter/material.dart';

class TimeSlotSelector extends StatelessWidget {
  final String? selectedTime;
  final Function(String) onTimeSelected;
  final List<String> timeSlots;

  final List<String> bookedSlots;

  final DateTime? selectedDate; // Add this parameter

  const TimeSlotSelector({
    super.key,
    this.selectedTime,
    this.bookedSlots = const [],
    required this.onTimeSelected,
    required this.timeSlots,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if selected date is today
    final isToday = selectedDate != null &&
        selectedDate!.year == today.year &&
        selectedDate!.month == today.month &&
        selectedDate!.day == today.day;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final time = timeSlots[index];
        final isSelected = selectedTime == time;

        final isBooked = bookedSlots.contains(time);
        final isPast = isToday && TimeSlotHelper.isTimeInPast(time, now);

        return TimeSlotItem(
          time: time,
          isSelected: isSelected,
          isBooked: isBooked,
          isPast: isPast,
          onTap: () => onTimeSelected(time),
          //so the onTap VoidCallback functions DON'T call the VoidCallback function's body, it declares the function prototype?
          //but if so, when does it ACTUALLY implement the called prototype function's body?
        );
      },
    );
  }
}

class TimeSlotItem extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isBooked;
  final bool isPast;
  //by default, all onTap functions are considered VoidCallback functions?
  //what's the difference between the ordinary functions and the VoidCallback functions? useCases, syntax, everything.
  //I think ordinaries happen to just call the function body, but VoidCallback functions only ever do upon a specific event, e.g. onTap, onSelected, onPressed...?
  //but like is this ALL the VoidCallback functions useCases out there?
  //and are there any other types to callBack functions except the VoidCallback?
  //and is it recursive in operational life cycle?
  final VoidCallback onTap;

  const TimeSlotItem({
    super.key,
    required this.time,
    required this.isBooked,
    required this.isSelected,
    required this.onTap,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = isBooked || isPast;

    return GestureDetector(
      // onTap: onTap,
      // remark:
      // onTap Callback Type: The onTap property expects a function with no parameters and no return value (void Function()?).
      // but how could you explain why the TimeSlotItem's onTap couldn't implement the shortHand conditional line (onTap:  isBooked ? null : () => onTap,), and the GestureDetector onTap could, aren't they both VoidCallBacks?
      // and how could it be a callback function AND void Function() at the same time? are they both the same thing?
      // aren't they mutually exclusive? evidence: when I tried to assign this function body to the VoidCallBack, it gave me error: The argument type 'void Function()?' can't be assigned to the parameter type 'VoidCallback'.  (argument_type_not_assignable at [doctor_appointment_app] lib/presentation/widgets/date_and_time_page/time_slot_selector.dart:39)
      onTap: isDisabled ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey[300]
              : isSelected
              ? const Color(0xFF2E7CF6)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDisabled
                ? Colors.grey[400]!
                : isSelected
                ? const Color(0xFF2E7CF6)
                : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isDisabled
                  ? Colors.grey[600]
                  : isSelected
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
