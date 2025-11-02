// 5. Screen Wrapper
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/state_management/navigation_bar_bloc/navigation_bloc.dart';
import '../../../business_logic/state_management/navigation_bar_bloc/navigation_event.dart';
import '../../../business_logic/state_management/navigation_bar_bloc/navigation_state.dart';
import '../custom_nav_bar.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget child;
  final bool showNavBar;
  final bool showAppBar;
  final String? appBarTitle;

  const ScreenWrapper({
    super.key,
    required this.child,
    this.showNavBar = true,
    this.showAppBar = true,
    this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: showAppBar
          ? AppBar(
              title: Text(appBarTitle ?? ''),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_outlined),
              ),
            )
          : null,
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
