class TimeSlotHelper {
  // Generate time slots from doctor's working hours
  static List<String> generateSlotsFromRange(String startTime, String endTime) {
    print('=== DEBUG: Parsing Doctor Hours ===');
    print('Start Time from API: "$startTime"');
    print('End Time from API: "$endTime"');

    // Parse times like "14:00:00 PM" or "09:00:00 AM"
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);

    print('Parsed Start Hour (24h): $start');
    print('Parsed End Hour (24h): $end');

    List<String> slots = [];

    // Generate 30-minute intervals
    for (int hour = start; hour < end; hour++) {
      slots.add(_formatTime12Hour(hour, 0));
      slots.add(_formatTime12Hour(hour, 30));
    }

    print('Generated slots: $slots');
    return slots;
  }

  // Parse time string to hour (24-hour format)
  static int _parseTime(String timeStr) {
    // Clean the string first
    timeStr = timeStr.trim().toUpperCase();

    print('Parsing time: "$timeStr"');

    // Handle the weird format "14:00:00 PM"
    // If it contains both 24-hour time AND AM/PM, remove AM/PM
    final hourMatch = RegExp(r'^(\d{1,2})').firstMatch(timeStr);
    if (hourMatch == null) {
      print('  Could not find hour, defaulting to 9');
      return 9; // Default to 9 AM
    }

    int hour = int.parse(hourMatch.group(1)!);
    print('  Extracted hour: $hour');

    // Check if this looks like invalid format (24-hour with AM/PM)
    if (hour >= 13 && (timeStr.contains('PM') || timeStr.contains('AM'))) {
      print('  WARNING: Invalid format - 24-hour time with AM/PM suffix');
      print('  Using hour as-is: $hour');
      return hour; // Just use the 24-hour value
    }

    // Normal 12-hour to 24-hour conversion
    if (timeStr.contains('PM')) {
      if (hour != 12) {
        hour += 12;
      }
      print('  PM detected, converted to: $hour');
    } else if (timeStr.contains('AM') && hour == 12) {
      hour = 0;
      print('  12 AM detected, converted to: $hour');
    }

    return hour;
  }

  // Format hour and minute to "HH:MM AM/PM" (12-hour format)
  static String _formatTime12Hour(int hour24, int minute) {
    String period = 'AM';
    int hour12 = hour24;

    if (hour24 >= 12) {
      period = 'PM';
      if (hour24 > 12) {
        hour12 = hour24 - 12;
      }
    }

    // Handle midnight (0:00)
    if (hour24 == 0) {
      hour12 = 12;
    }

    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hour12:$minuteStr $period';
  }

  // Helper to parse "Monday, December 15, 2025 2:00 PM" to DateTime
  static DateTime? parseAppointmentTime(String appointmentTime) {
    try {
      print('Parsing appointment time: "$appointmentTime"');

      // Clean the string (remove extra spaces)
      final cleanedTime = appointmentTime.trim().replaceAll(RegExp(r'\s+'), ' ');
      print('Cleaned: "$cleanedTime"');

      // Expected format: "Monday, December 15, 2025 2:00 PM"
      // or variations like: "Monday, December 15, 2025 2:00 PM"

      // Split by spaces
      final parts = cleanedTime.split(' ');
      print('Parts: $parts (${parts.length} parts)');

      // We need at least 5 parts: DayOfWeek, Month, Day, Year, Time, AM/PM
      if (parts.length < 5) {
        print('Not enough parts for parsing');
        return null;
      }

      // Find indices
      final monthIndex = 1; // December
      final dayIndex = 2;   // 15,
      final yearIndex = 3;  // 2025
      final timeIndex = 4;  // 2:00
      final periodIndex = 5; // PM

      // Parse month
      final monthStr = parts[monthIndex];
      final monthMap = {
        'January': 1, 'February': 2, 'March': 3, 'April': 4,
        'May': 5, 'June': 6, 'July': 7, 'August': 8,
        'September': 9, 'October': 10, 'November': 11, 'December': 12,
      };
      final month = monthMap[monthStr];
      if (month == null) {
        print('Invalid month: $monthStr');
        return null;
      }

      // Parse day (remove comma)
      final dayStr = parts[dayIndex].replaceAll(',', '');
      final day = int.tryParse(dayStr);
      if (day == null) {
        print('Invalid day: $dayStr');
        return null;
      }

      // Parse year
      final yearStr = parts[yearIndex];
      final year = int.tryParse(yearStr);
      if (year == null) {
        print('Invalid year: $yearStr');
        return null;
      }

      // Parse time
      final timeStr = parts[timeIndex];
      final timeParts = timeStr.split(':');
      if (timeParts.length != 2) {
        print('Invalid time format: $timeStr');
        return null;
      }

      var hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) {
        print('Invalid hour/minute: $timeStr');
        return null;
      }

      // Parse AM/PM
      if (periodIndex < parts.length) {
        final period = parts[periodIndex].toUpperCase();
        print('Period: $period, Hour before: $hour');

        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }
        print('Hour after conversion: $hour');
      }

      final result = DateTime(year, month, day, hour, minute);
      print('Successfully parsed to: $result');
      return result;

    } catch (e) {
      print('Error parsing appointment time "$appointmentTime": $e');
      return null;
    }
  }

// Helper to extract time string in format "2:00 PM"
  static String? extractTimeString(String appointmentTime) {
    try {
      print('Extracting time from: "$appointmentTime"');

      // Clean the string
      final cleanedTime = appointmentTime.trim().replaceAll(RegExp(r'\s+'), ' ');

      // Expected format: "Monday, December 15, 2025 2:00 PM"
      final parts = cleanedTime.split(' ');

      if (parts.length >= 6) {
        final timeStr = parts[4]; // "2:00"
        final periodStr = parts[5]; // "PM"

        // Convert to standard format (remove leading zero if needed)
        final timeParts = timeStr.split(':');
        if (timeParts.length == 2) {
          final hour = int.tryParse(timeParts[0]);
          final minute = timeParts[1];

          if (hour != null) {
            // Remove leading zero for single-digit hours
            final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
            final result = '$displayHour:$minute $periodStr';
            print('Extracted time: $result');
            return result;
          }
        }
      }

      return null;
    } catch (e) {
      print('Error extracting time: $e');
      return null;
    }
  }

  // Helper method to check if a time slot is in the past
  static bool isTimeInPast(String timeString, DateTime now) {
    try {
      // Parse time like "2:00 PM"
      final timeParts = timeString.split(' ');
      final time = timeParts[0]; // "2:00"
      final period = timeParts[1]; // "PM"

      final timeComponents = time.split(':');
      if (timeComponents.length != 2) return false;

      int hour = int.parse(timeComponents[0]);
      final minute = int.parse(timeComponents[1]);

      // Convert to 24-hour format
      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      // Create DateTime for this time slot today
      final slotTime = DateTime(now.year, now.month, now.day, hour, minute);

      // Check if slot time is before current time
      return slotTime.isBefore(now);
    } catch (e) {
      print('Error parsing time $timeString: $e');
      return false;
    }
  }
}