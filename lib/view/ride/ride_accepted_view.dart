import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rideshare/view/chat/chat_view.dart';

class RideAcceptedView extends StatefulWidget {
  final String roomId;
  final String driverName;

  const RideAcceptedView({
    super.key,
    required this.roomId,
    required this.driverName,
  });

  @override
  State<RideAcceptedView> createState() => _RideAcceptedViewState();
}

class _RideAcceptedViewState extends State<RideAcceptedView> {
  GoogleMapController? mapController;

  LatLng driverPosition = const LatLng(0, 0);
  LatLng riderPosition = const LatLng(24.7136, 46.6753);

  @override
  void initState() {
    super.initState();

    // Listen to the driver's location
    FirebaseFirestore.instance
        .collection("drivers_live_location")
        .doc("Uxfc5zJgFui6ndkj6jgdP")
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      double lat = data["lat"];
      double lng = data["lng"];

      setState(() {
        driverPosition = LatLng(lat, lng);
      });

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(driverPosition),
        );
      }
    });

    // Get rider pickup position
    FirebaseFirestore.instance
        .collection("ride_requests")
        .doc(widget.roomId)
        .get()
        .then((snapshot) {
      if (!snapshot.exists) return;

      double lat = snapshot.data()?["pickupLat"] ?? 24.7136;
      double lng = snapshot.data()?["pickupLng"] ?? 46.6753;

      setState(() {
        riderPosition = LatLng(lat, lng);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver: ${widget.driverName}"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: riderPosition,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("driver"),
                  position: driverPosition,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue,
                  ),
                ),
                Marker(
                  markerId: const MarkerId("rider"),
                  position: riderPosition,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
              },
              onMapCreated: (controller) => mapController = controller,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatView(roomId: widget.roomId),
                  ),
                );
              },
              child: const Text(
                "Open Chat",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
     ),
);
}
}