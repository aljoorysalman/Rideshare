import 'package:rideshare/model/ride/ride_model.dart';
import 'package:rideshare/model/users/driver_model.dart';

class RatingArgs {
  final RideModel ride;
  final DriverModel driver;

  RatingArgs({
    required this.ride,
    required this.driver,
  });
}
