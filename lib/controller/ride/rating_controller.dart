import 'package:cloud_firestore/cloud_firestore.dart';

class RatingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///  Store ratings, update the driver's overall rating
  Future<bool> handleDriverRating({
    required String driverId,
    required double rating, 
    required String feedback,
    required String rideId,
  }) async {
    if (rating < 1.0 || rating > 5.0) return false;

    try {
      await _firestore.runTransaction((transaction) async {
        // أ. تخزين التقييم الجديد
        final ratingRef = _firestore.collection('ratings').doc();
        transaction.set(ratingRef, {
          'driverId': driverId,
          'rideId': rideId,
          'rating': rating,
          'feedback': feedback,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // ب. تحديث تقييم السائق الإجمالي
        final driverRef = _firestore.collection('drivers').doc(driverId);
        final driverSnapshot = await transaction.get(driverRef);

        final currentTotalRating = driverSnapshot.data()?['totalRating'] ?? 0.0;
        final currentRatingCount = driverSnapshot.data()?['ratingCount'] ?? 0;

        final newRatingCount = currentRatingCount + 1;
        final newTotalRating = currentTotalRating + rating;
        final newAverageRating = newTotalRating / newRatingCount;

        transaction.set(driverRef, {
          'averageRating': double.parse(newAverageRating.toStringAsFixed(2)),
          'totalRating': newTotalRating,
          'ratingCount': newRatingCount,
        }, SetOptions(merge: true)); // نستخدم merge للحفاظ على البيانات الأخرى للسائق
      });

      return true;
    } catch (e) {
      print(' Critical Error during rating transaction: $e');
      return false;
    }
  }
}