import 'package:doctor_appointment_app/presentation/screens/booking_appointment/date_and_time.dart';
import 'package:doctor_appointment_app/presentation/screens/home_page.dart';
import 'package:doctor_appointment_app/presentation/screens/profile_screen.dart';
import 'package:doctor_appointment_app/presentation/screens/splash_screen.dart';
import 'package:doctor_appointment_app/presentation/widgets/screen_wrapper/main_nav_screen.dart';
import 'package:doctor_appointment_app/presentation/widgets/screen_wrapper/three_page_booking_appointment.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ThreePageBookingAppointment(),
    );
  }
}
//todo: navigation between pages
//todo: working icons onPressed
//todo: studying the implementation for the nav bar/screen wrapper/3_page_appointment_thing (appointment type selector, time slot selector and their bloc files)