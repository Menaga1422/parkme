import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingModel
{
  String parkName;
  String? _parkId;

  set parkId(String? value) {
    _parkId = value;
  }

  String? get parkId => _parkId;
  String contactNumber;
  LatLng location; //change to latlng
  int price;
  String userId;
  int totalSlots;
  int availableSlots;
  String parkingType;

  ParkingModel({required this.parkName,required this.contactNumber,required this.location,
    required this.price,required this.userId,required this.totalSlots,required this.availableSlots,required this.parkingType});

}