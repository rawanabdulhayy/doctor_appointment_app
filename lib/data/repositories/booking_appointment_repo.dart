import 'package:dio/dio.dart';
import 'package:doctor_appointment_app/core/helper_widgets/time_slot_helper.dart';
import 'package:flutter/cupertino.dart';
import '../../business_logic/repositaries_interfaces/booking_repo_interface.dart';
import '../models/appointment_model.dart';

class BookingRepositoryImpl implements BookingRepositoryInterface {
  final String baseUrl;
  final String? authToken;
  final Dio dio;

  BookingRepositoryImpl({
    required this.baseUrl,
    required this.authToken,
    required this.dio,
  });

  @override
  Future<List<String>> getBookedSlots({
    required int doctorId,
    required DateTime date,
  }) async {
    try {
      debugPrint('=== Fetching booked slots for Dr $doctorId on ${date.toString()} ===');

      // Use the correct endpoint: /appointment/index
      final response = await dio.get(
        '$baseUrl/appointment/index',
        options: Options(
          headers: {
            if (authToken != null) 'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List? ?? [];
        debugPrint('Found ${data.length} total appointments');

        final bookedSlots = <String>[];

        for (var appointmentJson in data) {
          try {
            // Parse appointment
            final appointment = Appointment.fromJson(appointmentJson);

            debugPrint('Checking appointment ${appointment.id} for Dr ${appointment.doctor.id}');

            // Check if appointment is for the requested doctor
            if (appointment.doctor.id == doctorId) {
              debugPrint('Appointment is for requested doctor');

              // Parse appointment time (e.g., "Monday, December 15, 2025 2:00 PM")
              debugPrint('Raw appointment_time: ${appointment.appointmentTime}');

              final appointmentDateTime = TimeSlotHelper.parseAppointmentTime(appointment.appointmentTime);

              if (appointmentDateTime != null) {
                debugPrint('Parsed date: $appointmentDateTime');
                debugPrint('Target date: $date');

                // Check if appointment is on the requested date
                if (appointmentDateTime.year == date.year &&
                    appointmentDateTime.month == date.month &&
                    appointmentDateTime.day == date.day) {

                  debugPrint('Appointment is on target date!');

                  // Extract time in format "2:00 PM"
                  final timeStr = TimeSlotHelper.extractTimeString(appointment.appointmentTime);
                  if (timeStr != null) {
                    bookedSlots.add(timeStr);
                    debugPrint('Added booked slot: $timeStr');
                  }
                }
              } else {
                debugPrint('Could not parse appointment time');
              }
            }
          } catch (e) {
            debugPrint('Error processing appointment: $e');
          }
        }

        debugPrint('Total booked slots for this date: $bookedSlots');
        return bookedSlots;

      } else {
        debugPrint('API error: ${response.statusCode} - ${response.data}');
        return [];
      }

    } on DioException catch (e) {
      debugPrint('Dio error: ${e.message}');
      debugPrint('Request URL: ${e.requestOptions.uri}');
      debugPrint('Response: ${e.response?.data}');
      return [];
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return [];
    }
  }
  @override
  Future<String> createBooking({
    required int doctorId,
    required String startTime, // This will now be "Monday, December 15, 2025 2:00 PM"
  }) async {
    try {
      debugPrint('=== Creating Booking ===');
      debugPrint('Doctor ID: $doctorId');
      debugPrint('Start Time (full format): $startTime');

      final response = await dio.post(
        '$baseUrl/appointment/store',
        data: {
          'doctor_id': doctorId,
          'start_time': startTime, // Send the full formatted string
        },
        options: Options(
          headers: {
            if (authToken != null) 'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Response Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bookingId = response.data['data']['id']?.toString() ?? 'Success';
        debugPrint('Booking created with ID: $bookingId');
        return bookingId;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create booking');
      }
    } on DioException catch (e) {
      debugPrint('Dio Error: ${e.response?.data}');
      rethrow;
    }
  }

  @override
  Future<List<Appointment>> getUserAppointments() async {
    try {
      final response = await dio.get(
        '$baseUrl/appointment/index',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Appointment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load appointments');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load appointments: $e');
    }
  }
}