import 'package:flutter/material.dart';
import 'package:rideshare/core/constants/app_colors.dart';
import 'package:rideshare/view/ride/home_view.dart';
import 'package:rideshare/view/profile/student_profile_view.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex; // highlights the active page
  final Function(int)? onTap; // callback to parent (optional)

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onItemTapped(int index) {
    //  prevent reloading same page
    if (index == widget.currentIndex) return;

    //  navigate to correct screen
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentProfileView()),
        );
        break;
    
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: _onItemTapped,
      backgroundColor: AppColors.background, //  consistent background
      selectedItemColor: AppColors.primary, // active icon color
      unselectedItemColor: Colors.grey, // inactive color
      selectedIconTheme: const IconThemeData(size: 30), //  active icon size
      unselectedIconTheme: const IconThemeData(size: 28), //  equal inactive icons
      type: BottomNavigationBarType.fixed, // ensures equal spacing
      elevation: 10, // small shadow for floating look

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded), // Home
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded), // Profile
          label: '',
        ),
      ],
    );
  }
}
