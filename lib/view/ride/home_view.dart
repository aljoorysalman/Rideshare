import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rideshare/view/ride/request_ride_view.dart';
import 'package:rideshare/core/constants/app_colors.dart';
import 'package:rideshare/view/widgets/custom_button.dart';
import 'package:rideshare/view/widgets/bottom_nav_bar.dart';
import 'package:rideshare/view/profile/profile_view.dart';
import 'package:rideshare/view/ride/reserve_ride_view.dart';

/// The main container that holds the bottom bar and swaps between tabs.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
   final List<Widget> pages = [
  const _HomeContent(),
  const ProfileView(),
    ];


    return Scaffold(
      backgroundColor: AppColors.background,
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}

/// The home tab content (two main action buttons)
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //  First section: Request Ride
            Image.asset('img/car.png', height: 80),
            const Gap(16),
            CustomButton(
              text: 'Request a Ride',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RequestRideView(),
                  ),
                );
              },
            ),

            const Gap(100), // spacing between the two ride types

            //  Second section: Schedule Ride
            Image.asset('img/clock.png', height: 80),
            const Gap(16),
            CustomButton(
              text: 'Reserve a Ride',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReserveRideView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
