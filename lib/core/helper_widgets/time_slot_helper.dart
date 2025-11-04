class TimeSlotHelper {
  // Generate time slots with 30-minute intervals
  static List<String> generateTimeSlots({
    int startHour = 8,
    int endHour = 18,
    int intervalMinutes = 30,
  }) {
    List<String> slots = [];

    for (int hour = startHour; hour < endHour; hour++) {
      for (int minute = 0; minute < 60; minute += intervalMinutes) {
        final time = _formatTime(hour, minute);
        slots.add(time);
      }
    }

    return slots;
  }

  // Generate specific time slots
  static List<String> customTimeSlots() {
    return [
      '08.00 AM',
      '08.30 AM',
      '09.00 AM',
      '09.30 AM',
      '10.00 AM',
      '11.00 AM',
    ];
  }

  static String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');

    return '${displayHour.toString().padLeft(2, '0')}.$displayMinute $period';
  }
}