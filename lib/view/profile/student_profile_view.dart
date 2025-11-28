import 'package:flutter/material.dart';
import 'package:rideshare/controller/student_profile_controller.dart';
import 'package:rideshare/model/student_profile_model.dart';
import 'package:rideshare/view/widgets/bottom_nav_bar.dart';
import 'package:rideshare/core/constants/app_colors.dart';

class StudentProfileView extends StatefulWidget {
  const StudentProfileView({super.key});

  @override
  State<StudentProfileView> createState() => _StudentProfileViewState();
}

class _StudentProfileViewState extends State<StudentProfileView> {
  final StudentProfileController _controller = StudentProfileController();
  late Future<StudentProfile> _futureProfile;

  bool isEditingPhone = false;
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureProfile = _controller.getStudentProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: FutureBuilder<StudentProfile>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, size: 45),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        profile.email,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Phone Number",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),

                Text(
                  profile.phone,
                  style: const TextStyle(fontSize: 16),
                ),

                if (!isEditingPhone)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEditingPhone = true;
                        phoneController.text = profile.phone;
                      });
                    },
                    child: const Text("Do you want to change the number?"),
                  ),

                if (isEditingPhone)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Enter new phone number",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await _controller.updatePhone(
                            profile,
                            phoneController.text,
                          );
                          setState(() {
                            isEditingPhone = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Phone number updated"),
                            ),
                          );
                        },
                        child: const Text("Confirm"),
                      ),
                    ],
                  ),

                const SizedBox(height: 30),

                const Text(
                  "Previous Trips",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Column(
                  children: profile.pastTrips
                      .map(
                        (trip) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text(trip),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 30),

                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: const BottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}