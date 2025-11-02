// 5. Screen Wrapper
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/state_management/navigation_bloc.dart';
import '../../business_logic/state_management/navigation_event.dart';
import '../../business_logic/state_management/navigation_state.dart';
import 'custom_nav_bar.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget child;
  final bool showNavBar;

  const ScreenWrapper({
    super.key,
    required this.child,
    this.showNavBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
      bottomNavigationBar: showNavBar
          ? BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return CustomBottomNavBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<NavigationBloc>().add(NavigateToPage(index));
            },
          );
        },
      )
          : null,
    );
  }
}