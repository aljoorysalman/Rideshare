import 'package:cloud_firestore/cloud_firestore.dart';

class RatingController {
  Future<String?> submitRating({
    required int stars,
    required String feedback,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('ratings').add({
        'stars': stars,
        'feedback': feedback,
        'driverID': 'driver123',  
        'userID': 'user123',     
        'createdAt': Timestamp.now(),
      });

      return null; 
    } catch (e) {
      return "Error: $e";
    }
  }
}
