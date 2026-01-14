import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<Position?> getCurrentPosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return null;
      }
      
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      print('❌ Location error: $e');
      return null;
    }
  }
  
  static Future<String?> getAddressFromCoordinates(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        final parts = <String>[];
        
        if (place.locality?.isNotEmpty ?? false) {
          parts.add(place.locality!);
        }
        if (place.administrativeArea?.isNotEmpty ?? false) {
          parts.add(place.administrativeArea!);
        }
        if (place.country?.isNotEmpty ?? false) {
          parts.add(place.country!);
        }
        
        return parts.join(', ');
      }
    } catch (e) {
      print('❌ Geocoding error: $e');
    }
    return null;
  }
  
  static Future<Map<String, dynamic>?> getCurrentLocationWithAddress() async {
    final position = await getCurrentPosition();
    if (position == null) return null;
    
    final address = await getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );
    
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address ?? 'Unknown location',
    };
  }
}
