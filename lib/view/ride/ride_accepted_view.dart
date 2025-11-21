import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/controller/driver_service.dart';
import 'package:rideshare/model/driver_model.dart';
import 'package:rideshare/core/constants/app_colors.dart';
import 'package:rideshare/view/chat/chat_screen.dart';
import 'package:rideshare/view/widgets/custom_button.dart';



class AcceptedRideView extends StatelessWidget {
  final String driverID;
  final LatLng pickupLatLng;

  late final String pickupPin;

  AcceptedRideView({
    super.key,
    required this.driverID,
    required this.pickupLatLng,
  }) {
    pickupPin = _generatePickupPin();   
  }

 
  String _generatePickupPin() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return (random % 9000 + 1000).toString(); // 4-digit PIN
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: StreamBuilder<DriverModel?>(
          stream: DriverService().streamDriver(driverID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("Driver data not available"),
              );
            }

            final driver = snapshot.data!;

            //  Convert driver.location (GeoPoint) to LatLng for the map.
            final LatLng driverLatLng = (driver.location != null)
                ? LatLng(
                    driver.location!.latitude,
                    driver.location!.longitude,
                  )
                : pickupLatLng; // fallback if location is null

            final Set<Marker> markers = {
              Marker(
                markerId: const MarkerId('pickup'),
                position: pickupLatLng,
                infoWindow: const InfoWindow(title: 'Pickup'),
              ),
              Marker(
                markerId: const MarkerId('driver'),
                position: driverLatLng,
                infoWindow: const InfoWindow(title: 'Driver'),
              ),
            };

            return Column(
              children: [
                const SizedBox(height: 12),

                // ---------------- MAP ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: SizedBox(
                      height: 230,
                     child: GoogleMap(
                        key: UniqueKey(),  //  forces rebuild when StreamBuilder fires
                        initialCameraPosition: CameraPosition(
                        target: pickupLatLng,
                        zoom: 15.5,
                      ),
  markers: markers,
  zoomControlsEnabled: false,
  myLocationButtonEnabled: false,
  myLocationEnabled: false,
),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ---------------- BOTTOM PANEL ----------------
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //---------------- DRIVER INFO + BUTTONS ----------------
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Driver Name
                                    Text(
                                      driver.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Rating Row
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          driver.rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                              
                                    Text(

                                       "${driver.carModel} • ${driver.carColor} • ${driver.plateNumber}",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 20),

                              Column(
                                children: [
                                  // CALL BUTTON
                                  _circleButton(
                                    icon: Icons.call,
                                    onTap: () {
                                      // TODO: add phone call logic later
                                    },
                                  ),
                                  const SizedBox(height: 12),

                                  // MESSAGE BUTTON
                                  _circleButton(
                                    icon: Icons.message_outlined,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const ChatScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          //---------------- PICKUP PIN ----------------
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Text(
                                "PickupPIN: $pickupPin",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),

                          //---------------- CANCEL RIDE BUTTON ----------------
                        Center(
                         child: CustomButton(
                        text: "Cancel ride",
                        onPressed: () => Navigator.pop(context),
                        isFullWidth: false,
                        borderRadius: 30,
                        padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                       ),
                       color: Colors.black,
                       textColor: Colors.white,
                      ),
 ),


                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

            // SMALL CIRCULAR BUTTON FOR CALL/CHAT
            static Widget _circleButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return Material(
    color: const Color(0xFFD9D9D9), // light grey
    shape: const CircleBorder(),
    elevation: 0,
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Padding(   
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,          
          size: 22,
          color: Colors.black,
        ),
      ),
    ),
  );
}
}