import 'package:doctor_appointment_app/presentation/screens/authentication_screens/auth_wrapper.dart';
import 'package:doctor_appointment_app/presentation/screens/authentication_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/state_management/auth_bloc/authentication_bloc.dart';
import '../../business_logic/state_management/doctor_information_bloc/doctor_information_bloc.dart';
import '../../business_logic/state_management/user_bloc/user_bloc.dart';
import '../../core/dependency_injection/injection_container.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Content: Faint background logo pattern
          Positioned(
            top: height * 0.25,
            child: Image.asset(
              "assets/images/splash_screen/app_logo_background.png",
              fit: BoxFit.fill,
              width: width,
            ),
          ),

          // Foreground Content: Main content
          SafeArea(
            // Alternative: Manual Padding with MediaQuery.of(context).padding.top (harder)
            // Column inside a stack is okay.
            child: Column(
              children: [
                // Top Foreground: Logo bar.
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/splash_screen/app_logo.png",
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 8),
                      Image.asset("assets/images/splash_screen/app_name.png", width: 120),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Middle Foreground: Doctor image with gradient overlay.
                Expanded(
                  // Only works inside Column/Row/Flex
                  // Alternative: Flexible (allows child to be smaller than available space)
                  child: Stack(
                    children: [
                      // Doctor image

                      // Positioned.fill = shortcut for Positioned(top: 0, left: 0, right: 0, bottom: 0)
                      // Alternative: Container with width: double.infinity, height: double.infinity (more verbose)
                      Positioned.fill(
                        child: Image.asset(
                          "assets/images/onboarding_screen/onboarding_dr.png",
                          fit: BoxFit.contain,
                          // BoxFit.cover: Scales image to cover entire area (may crop sides)
                          // vs BoxFit.contain: Fits entire image and maintains aspect ratio (may show empty space)
                          // vs BoxFit.fill: Stretches image (distorts aspect ratio)
                        ),
                      ),

                      // Gradient overlay at bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        // Anchors to bottom
                        height: 200,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromRGBO(255, 255, 255, 0),
                                Color.fromRGBO(255, 255, 255, 1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Foreground: text and button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Best Doctor",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF247CFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        "Appointment App",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF247CFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Manage and schedule all of your medical appointments easily with Docdoc to get a new experience.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return MultiBlocProvider(
                                  providers: [
                                    BlocProvider<AuthBloc>(
                                      create: (context) => sl<AuthBloc>(),
                                    ),
                                    BlocProvider<DoctorBloc>(
                                      create: (context) => sl<DoctorBloc>(),
                                    ),
                                    BlocProvider<UserBloc>(
                                      create: (context) => sl<UserBloc>(),
                                    ),
                                  ],
                                  child: AuthWrapper(),
                                );
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF247CFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
