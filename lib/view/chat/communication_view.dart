import 'package:flutter/material.dart';
import 'package:rideshare/core/constants/app_colors.dart';
import 'package:rideshare/view/widgets/bottom_nav_bar.dart';
import 'package:rideshare/view/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunicationView extends StatefulWidget {
  const CommunicationView({super.key});

  @override
  State<CommunicationView> createState() => _CommunicationViewState();
}

class _CommunicationViewState extends State<CommunicationView> {
  int _currentIndex = 1;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  // 🔥 تجيب آخر roomId من Firestore
  Future<String?> _getLatestRoomId() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return snapshot.docs.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String? roomId = await _getLatestRoomId();

            if (roomId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No chats available")),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(roomId: roomId),
              ),
            );
          },
          child: const Text('Open Chat'),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
     ),
);
}
}