import 'package:geolocator/geolocator.dart';

class LocationService {

  static Future<void> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        /// Permissions are denied, next time you could try requesting permissions again
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      /// Permissions are denied forever
      throw Exception('Location permissions are permanently denied');
    }
  }

  static Future<Position> getCurrentLocation() async {
    await _requestPermission();
    return await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
  }
}