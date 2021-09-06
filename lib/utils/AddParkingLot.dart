
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkme/utils/ParkingModel.dart';

Future putParkingInfo(ParkingModel parkLot) async{
  Map<String, dynamic> parkData= {"parkName":parkLot.parkName,"location":parkLot.location,"contactNo":parkLot.contactNumber,"price":parkLot.price,"userId":parkLot.userId};
  await FirebaseFirestore.instance.collection("parkLot").doc().set(parkData);
  print(">>>>>>>>>>>>>>ParkingDetailsInserted");
}
