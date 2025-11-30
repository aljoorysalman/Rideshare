import 'package:flutter/material.dart';
import 'package:rideshare/controller/reserve_ride_controller.dart';

class ReserveRideView extends StatefulWidget {
  const ReserveRideView({super.key});

  @override
  State<ReserveRideView> createState() => _ReserveRideViewState();
}

class _ReserveRideViewState extends State<ReserveRideView> {
  final pickupController = TextEditingController();
  final dropoffController = TextEditingController();
  final seatsController = TextEditingController(text: '1');

  final controller = ReserveRideController();

  DateTime? selectedTime;

  @override
  void dispose() {
    pickupController.dispose();
    dropoffController.dispose();
    seatsController.dispose();
    super.dispose();
  }

  // اختيار التاريخ + الوقت
  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (time == null) return;

    setState(() {
      selectedTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String _formatSelectedTime() {
    if (selectedTime == null) return 'Select date & time';

    final d = selectedTime!;
    final yy = d.year.toString();
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');

    return '$yy-$mm-$dd  $hh:$min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve a Ride'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pickup address'),
              const SizedBox(height: 4),
              TextField(
                controller: pickupController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter pickup location',
                ),
              ),
              const SizedBox(height: 16),

              const Text('Drop-off address'),
              const SizedBox(height: 4),
              TextField(
                controller: dropoffController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter drop-off location',
                ),
              ),
              const SizedBox(height: 16),

              const Text('Seats'),
              const SizedBox(height: 4),
              TextField(
                controller: seatsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '1',
                ),
              ),
              const SizedBox(height: 16),

              const Text('Reservation time'),
              const SizedBox(height: 4),
              OutlinedButton(
                onPressed: _pickDateTime,
                child: Text(_formatSelectedTime()),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final validation = controller.validateReserveInputs(
                      pickupAddress: pickupController.text,
                      dropoffAddress: dropoffController.text,
                      // مؤقتًا نحط إحداثيات 0, رح نستبدلها لاحقًا بالماب
                      pickupLat: 0,
                      pickupLng: 0,
                      dropoffLat: 0,
                      dropoffLng: 0,
                      scheduledTime: selectedTime,
                      seats: int.tryParse(seatsController.text) ?? 1,
                    );

                    if (validation != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(validation)),
                      );
                      return;
                    }

                    final reservation = controller.createReservation(
                      pickupAddress: pickupController.text,
                      dropoffAddress: dropoffController.text,
                      pickupLat: 0,
                      pickupLng: 0,
                      dropoffLat: 0,
                      dropoffLng: 0,
                      scheduledTime: selectedTime!,
                      riderId: "demoUserId", // TODO: استبدليها بـ Auth UID
                      direction: "HomeToCampus", // TODO: حطي المنطق اللي تبغونه
                      seats: int.tryParse(seatsController.text) ?? 1,
                    );

                    await controller.saveReservation(reservation);

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reservation created successfully'),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: const Text('Confirm Reservation'),
                ),
              ),
            ],
          ),
        ),
     ),
);
}
}