// 6. Main Navigation Container
import 'package:doctor_appointment_app/presentation/screens/profile_screen.dart';
import 'package:doctor_appointment_app/presentation/widgets/screen_wrapper/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/state_management/navigation_bar_bloc/navigation_bloc.dart';
import '../../../business_logic/state_management/navigation_bar_bloc/navigation_state.dart';
import '../../screens/home_page.dart';
import '../../screens/static_screens.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return ScreenWrapper(
            child: IndexedStack(
              index: state.currentIndex,
              children: const [
                HomePage(),
                MessagesPage(),
                CalendarPage(),
                ProfileScreen(),
                SearchPage(),
              ],
            ),
          );
        },
      ),
    );
  }
}