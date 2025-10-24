import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    delayForThreeSeconds();
  }

  Future<void> delayForThreeSeconds()async {
    await Future.delayed(const Duration(seconds: 3));
    // Make sure context is still valid
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
      return const OnboardingScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/app_logo_background.png",
              fit: BoxFit.fill,
              width: double.infinity,
            ),
            Positioned(
              top: height * 0.22,
              left: width * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/app_logo.png", width: width * 0.2),
                  SizedBox(width: width * 0.05),
                  // Text(
                  //   'Docdoc',
                  //   style: TextStyle(
                  //     fontSize: 50,
                  //     color: Color.fromRGBO(16, 36, 36, 1),
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  Image.asset(
                    "assets/images/app_name.png",
                    fit: BoxFit.contain,
                    width: width * 0.4, // or whatever looks good
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Image not found');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
