
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkme/utils/ParkingModel.dart';

Future putParkingInfo(ParkingModel parkLot) async{
  Map<String, dynamic> parkData= {"parkName":parkLot.parkName,"location": GeoPoint(parkLot.location.latitude,
      parkLot.location.longitude),"contactNo":parkLot.contactNumber,"price":parkLot.price,"userId":parkLot.userId,
      "totalSlots":parkLot.totalSlots,"availableSlots":parkLot.availableSlots,"parkingType": parkLot.parkingType,
  };
  await FirebaseFirestore.instance.collection("parkLot").doc().set(parkData);
  print(">>>>>>>>>>>>>>ParkingDetailsInserted");

}
