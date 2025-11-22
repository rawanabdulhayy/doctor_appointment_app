import 'package:doctor_appointment_app/presentation/screens/booking_appointment/date_and_time.dart';
import 'package:doctor_appointment_app/presentation/screens/home_page.dart';
import 'package:doctor_appointment_app/presentation/screens/authentication_screens/login_screen.dart';
import 'package:doctor_appointment_app/presentation/screens/profile_screen.dart';
import 'package:doctor_appointment_app/presentation/screens/splash_screen.dart';
import 'package:doctor_appointment_app/presentation/widgets/screen_wrapper/main_nav_screen.dart';
import 'package:doctor_appointment_app/presentation/widgets/screen_wrapper/three_page_booking_appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic/state_management/auth_bloc/authentication_bloc.dart';
import 'core/dependency_injection/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (context) => sl<AuthBloc>(),
        child: LoginScreen(),
      ),
    );
  }
}
//todo: IMPLEMENT_ME: navigation between pages
//todo: IMPLEMENT_ME: working icons onPressed

//todo: REVIEW_ME: the nav bar files
//todo: REVIEW_ME: the screen wrapper files
//todo: REVIEW_ME: the 3_page_appointment_thing files (appointment type selector widget, time slot selector widget, summary screen, and their bloc files)

//todo: REVIEW_ME & LOOK_ME_UPS: looking up the needed-to-know info commented in all the dr info files. (screenshots taken)