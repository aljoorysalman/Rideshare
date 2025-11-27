import 'package:flutter/material.dart';
import '../../controller/ride/rating_controller.dart';
import 'package:rideshare/model/ride/ride_model.dart';
import 'package:rideshare/model/users/driver_model.dart';

class RatingPage extends StatefulWidget {
  final RideModel ride;
  final DriverModel driver;

  const RatingPage({
    super.key,
    required this.ride,
    required this.driver,
  });

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int selectedStars = 0;
  final TextEditingController feedbackController = TextEditingController();

  final RatingController ratingController = RatingController();

  Future<void> submitRating() async {
    if (selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a rating")),
      );
      return;
    }

    final success = await ratingController.handleDriverRating(
        driverId: widget.driver.userID,          // from DriverModel
       rideId: widget.ride.rideID,              // from RideModel
      rating: selectedStars.toDouble(),
    feedback: feedbackController.text.trim(),
);


    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong, try again.")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thank you for your feedback!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 60),

              const Text(
                "Rate Your Driver",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        selectedStars = index + 1;
                      });
                    },
                    icon: Icon(
                      Icons.star,
                      size: 40,
                      color: (index < selectedStars)
                          ? Colors.amber
                          : Colors.grey.shade300,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Additional feedback (Optional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: submitRating,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Submit Rating",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
