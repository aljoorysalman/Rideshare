class RatingModel {
  final int stars;
  final String feedback;
  final String driverID;
  final String userID;

  RatingModel({
    required this.stars,
    required this.feedback,
    required this.driverID,
    required this.userID,
  });

  Map<String, dynamic> toMap() {
    return {
      'stars': stars,
      'feedback': feedback,
      'driverID': driverID,
      'userID': userID,
      'createdAt': DateTime.now(),
    };
  }
}
