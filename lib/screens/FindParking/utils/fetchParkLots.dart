import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double distanceBetweenUsers(LatLng yourLocation, LatLng otherLocation){
  double distance = Geolocator.distanceBetween(yourLocation.latitude, yourLocation.longitude, otherLocation.latitude, otherLocation.longitude);
  return distance;
}