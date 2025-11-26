// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:rideshare/view/ride/ride_accepted_view.dart';

// class DriverHomeView extends StatefulWidget {
//   final String driverId;

//   const DriverHomeView({super.key, required this.driverId});

//   @override
//   State<DriverHomeView> createState() => _DriverHomeViewState();
// }

// class _DriverHomeViewState extends State<DriverHomeView> {
//   final Location location = Location();
//   GoogleMapController? mapController;
//   bool isUpdating = false;

//   String? pendingRoomId;
//   String? riderName;
//   String? pickupAddress;
//   String? dropoffAddress;

//   @override
//   void initState() {
//     super.initState();
//     _startLocationUpdates();
//     _listenForPendingRide();
//   }

//   // =========================================================
//   // ❶ الاستماع لأي رحلة جديدة بحالة pending
//   // =========================================================
//   void _listenForPendingRide() {
//     FirebaseFirestore.instance
//         .collection("ride_requests")
//         .where("status", isEqualTo: "pending")
//         .snapshots()
//         .listen((snapshot) {
//       if (snapshot.docs.isEmpty) return;

//       final data = snapshot.docs.first.data();
//       final roomId = snapshot.docs.first.id;

//       setState(() {
//         pendingRoomId = roomId;
//         riderName = data["riderId"];
//         pickupAddress = data["pickupAddress"];
//         dropoffAddress = data["dropoffAddress"];
//       });
//     });
//   }

//   // =========================================================
//   // ❷ قبول الرحلة
//   // =========================================================
//   Future<void> _acceptRide() async {
//     if (pendingRoomId == null) return;

//     await FirebaseFirestore.instance
//         .collection("ride_requests")
//         .doc(pendingRoomId)
//         .update({
//       "status": "accepted",
//       "driver_name": widget.driverId,
//     });

//     // انتقال السائق لشاشة RideAcceptedView
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => RideAcceptedView(
//           roomId: pendingRoomId!,
//           driverName: widget.driverId,
//         ),
//       ),
//     );
//   }

//   // =========================================================
//   // ❸ رفض الرحلة
//   // =========================================================
//   Future<void> _rejectRide() async {
//     if (pendingRoomId == null) return;

//     await FirebaseFirestore.instance
//         .collection("ride_requests")
//         .doc(pendingRoomId)
//         .update({
//       "status": "rejected",
//     });

//     setState(() {
//       pendingRoomId = null;
//     });
//   }

//   // =========================================================
//   // ❹ بث موقع السائق
//   // =========================================================
//   Future<void> _startLocationUpdates() async {
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) return;
//     }

//     PermissionStatus permission = await location.hasPermission();
//     if (permission == PermissionStatus.denied) {
//       permission = await location.requestPermission();
//       if (permission != PermissionStatus.granted) return;
//     }

//     location.changeSettings(
//       accuracy: LocationAccuracy.high,
//       interval: 2000,
//     );

//     location.onLocationChanged.listen((loc) {
//       if (!mounted) return;

//       FirebaseFirestore.instance
//           .collection("drivers_live_location")
//           .doc(widget.driverId)
//           .set({
//         "lat": loc.latitude,
//         "lng": loc.longitude,
//         "timestamp": DateTime.now().millisecondsSinceEpoch,
//       });

//       if (mapController != null &&
//           loc.latitude != null &&
//           loc.longitude != null) {
//         mapController!.animateCamera(
//           CameraUpdate.newLatLng(
//             LatLng(loc.latitude!, loc.longitude!),
//           ),
//         );
//       }
//     });

//     setState(() => isUpdating = true);
//   }

//   // =========================================================
//   // ❺ واجهة السائق
//   // =========================================================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver Dashboard"),
//         backgroundColor: Colors.black,
//       ),

//       body: Column(
//         children: [
//           // ======== الخريطة ========
//           Expanded(
//             child: GoogleMap(
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(24.7136, 46.6753),
//                 zoom: 15,
//               ),
//               onMapCreated: (controller) => mapController = controller,
//             ),
//           ),

//           // ======== عرض الطلب ========
//           if (pendingRoomId != null)
//             Container(
//               padding: const EdgeInsets.all(16),
//               color: Colors.grey.shade200,
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   Text(
//                     "New Ride Request",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Text("Pickup: $pickupAddress"),
//                   Text("Drop-off: $dropoffAddress"),
//                   const SizedBox(height: 10),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // زر قبول
//                       ElevatedButton(
//                         onPressed: _acceptRide,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 24, vertical: 12),
//                         ),
//                         child: const Text("Accept"),
//                       ),
//                       const SizedBox(width: 12),

//                       // زر رفض
//                       ElevatedButton(
//                         onPressed: _rejectRide,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 24, vertical: 12),
//                         ),
//                         child: const Text("Reject"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//           // ======== حالة البث ========
//           Container(
//             padding: const EdgeInsets.all(16),
//             width: double.infinity,
//             color: Colors.black,
//             child: Text(
//               isUpdating ? "🚗 بث الموقع يعمل..." : "⏳ جار تفعيل GPS...",
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ],
//      ),
// );
// }
// }