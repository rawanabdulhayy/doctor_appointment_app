import 'package:doctor_appointment_app/presentation/screens/authentication_screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/state_management/auth_bloc/authentication_bloc.dart';
import '../../../business_logic/state_management/auth_bloc/authentication_state.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_bloc.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_event.dart';
import '../../../core/helper_widgets/custom_snackbar.dart';
import '../../widgets/screen_wrapper/main_nav_screen.dart';
import '../splash_screen.dart';
import 'login_screen.dart';

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
//         // User is logged in - show main app
//         if (state is AuthSuccess) {
//           // Load doctors when authenticated
//           context.read<DoctorBloc>().add(LoadDoctorsList());
//           return MainNavigationScreen();
//         }
//
//         // Default: show login screen
//         // (AuthInitial, AuthUnauthenticated, or AuthError)
//         return LoginScreen();
//       },
//     );
//   }
// }

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Show success message when authentication succeeds
        if (state is AuthSuccess) {
          final user = state.authResponse.user;
          // final token = state.authResponse.token;
          SnackBarHelper.show(
            context,
            'Welcome back ${user.name}!',
            type: SnackBarType.success,
          );
          context.read<DoctorBloc>().add(LoadDoctorsList());
        }
      },
      builder: (context, state) {
        // if (state is AuthLoading) {
        //   // return SplashScreen(); // or Scaffold with loading
        //   return CircularProgressIndicator();
        // }
        if (state is AuthSuccess) {
          return MainNavigationScreen();
        }
        // Handle different auth screens based on state
        Widget screen;

        if (state is AuthShowSignup) {
          screen = const SignUp();
        } else if (state is AuthShowLogin ||
            state is AuthInitial ||
            state is AuthError) {
          screen = const LoginScreen();
        } else {
          screen = const LoginScreen(); // default
        }

        // Always wrap with BlocProvider
        // return BlocProvider.value(
        //   value: context.read<AuthBloc>(),
        //   child: screen,
        // );
        return screen;
      },
    );
  }
}