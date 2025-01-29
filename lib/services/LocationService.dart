import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static Future<void> initializeAndCacheLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
      ));

      // Cache the location
      final prefs = await SharedPreferences.getInstance();
      prefs.setDouble('latitude', position.latitude);
      prefs.setDouble('longitude', position.longitude);

      print("Location cached: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      print("Error initializing location: $e");
    }
  }

  static Future<Position?> getCachedLocation() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('latitude') && prefs.containsKey('longitude')) {
      return Position(
        latitude: prefs.getDouble('latitude')!,
        longitude: prefs.getDouble('longitude')!,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    }
    return null;
  }

  /// Requests location permissions and checks if location services are enabled.
  static Future<bool> requestLocationPermission() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    var status = await Permission.location.request();
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.restricted) {
      // Open app settings to allow user to enable location permissions
      await openAppSettings();
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      // Handle permanently denied permissions
      await openAppSettings();
      return false;
    }

    return status == PermissionStatus.granted;
  }

  /// Checks if location permissions are granted.
  static Future<bool> isLocationPermissionGranted() async {
    return await Permission.location.isGranted;
  }

  /// Retrieves the most accurate current location.
  static Future<Position?> getAccurateLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 10,
        ),
      );
      return position;
    } catch (e) {
      print('Error getting accurate location: $e');
      return null;
    }
  }

  /// Converts the coordinates into a human-readable address.
  static Future<String> getCurrentLocationAddress() async {
    try {
      Position? position = await getAccurateLocation();
      if (position != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          return '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        }
      }
    } catch (e) {
      print('Error converting coordinates to address: $e');
    }
    return 'Unable to fetch location address';
  }
}
