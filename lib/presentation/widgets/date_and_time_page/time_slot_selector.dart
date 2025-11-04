import 'package:flutter/material.dart';

class TimeSlotSelector extends StatelessWidget {
  final String? selectedTime;
  final Function(String) onTimeSelected;
  final List<String> timeSlots;

  const TimeSlotSelector({
    super.key,
    this.selectedTime,
    required this.onTimeSelected,
    required this.timeSlots,
  });

  @override
  Widget build(BuildContext context) {
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

        return TimeSlotItem(
          time: time,
          isSelected: isSelected,
          onTap: () => onTimeSelected(time),
        );
      },
    );
  }
}

class TimeSlotItem extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeSlotItem({
    super.key,
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7CF6) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFFBDBDBD),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}