import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jwt_auth/data/location_config.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<LocationData?> getUserLocation() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        double? latitude = position.latitude;
        double? longitude = position.longitude;

        return LocationData(latitude: latitude, longitude: longitude);
      } catch (e) {
        debugPrint('Error getting location: $e');
      }
    } else if (status.isPermanentlyDenied) {
      // Handle permanent denial
    } else {
      // Handle other denial cases
    }

    return null; // Return null if location is not available or denied
  }
}
