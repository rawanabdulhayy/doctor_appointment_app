// 4. Custom Bottom Navigation Bar Widget
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Bottom Navigation Bar
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                index: 0,
                hasNotification: false,
              ),
              _buildNavItem(
                icon: Icons.chat_bubble_outline,
                index: 1,
                hasNotification: true,
              ),
              const SizedBox(width: 70), // Space for center FAB
              _buildNavItem(
                icon: Icons.calendar_today_outlined,
                index: 2,
                hasNotification: false,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                index: 3,
                hasNotification: false,
                isProfile: true,
              ),
            ],
          ),
        ),

        // Floating Center Search Button
        Positioned(
          top: -25,
          child: GestureDetector(
            onTap: () => onTap(4), // Index 4 for search
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF2D6CFF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2D6CFF).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),

        // Bottom indicator line
        Positioned(
          bottom: 0,
          child: Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required bool hasNotification,
    bool isProfile = false,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Profile Picture or Icon
            if (isProfile)
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2D6CFF) : Colors.transparent,
                    width: 2,
                  ),
                ),
                // the backgroundImage property of CircleAvatar expects an ImageProvider, not an Image widget.
                // child: CircleAvatar(
                //   backgroundImage: Image.asset(
                //    "assets/images/user_profile_screen/avatar.png"
                //   ),
                // ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    "assets/images/user_profile_screen/avatar.png",
                  ),
                ),
              )
            else
              Icon(
                icon,
                color: isSelected ? const Color(0xFF2D6CFF) : Colors.grey[600],
                size: 28,
              ),

            // Notification Badge
            if (hasNotification)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
