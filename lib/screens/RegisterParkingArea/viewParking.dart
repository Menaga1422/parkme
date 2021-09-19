import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkme/screens/FindParking/parkLotDetails.dart';
import 'package:parkme/screens/RegisterParkingArea/viewParkingUsers.dart';
import 'package:parkme/utils/LocationHelpers.dart';
import 'package:parkme/utils/ParkingModel.dart';

import '../../theme.dart';

class ViewParking extends StatefulWidget {
  const ViewParking({Key? key}) : super(key: key);

  @override
  _ViewParkingState createState() => _ViewParkingState();
}

class _ViewParkingState extends State<ViewParking> {
  String? parkId;
  ParkingModel? parkLot;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOwnerParking();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parkme",
          style: GoogleFonts.rochester(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: (parkLot==null)?Container(
          padding: EdgeInsets.fromLTRB(20,100,20,20),
          child:Text("You dont have Parking Area \n To register parking tap add button",
            style: TextStyle(
              fontFamily: 'Lobster',
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: kSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ))
          :Container(
        child: OwnerParkLotInfo(parkingModel: parkLot!,),
        ),
    );
  }

  fetchOwnerParking() async{
    print(">>>>>>>>>>>>>>>fetchOwnerParkingFunction");
    String userId=FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("parkLot")
        .where("userId", isEqualTo: userId)
        .get()
        .then((value) {
      QueryDocumentSnapshot document=value.docs.first;
      print(document.id);
      parkLot=ParkingModel(parkName: document.get("parkName"),
          contactNumber: document.get("parkName"),
          location: LatLng(document["location"].latitude,document["location"].longitude),
          price: document.get("price"),
          totalSlots: document.get("totalSlots"),
          availableSlots: document.get("availableSlots"),
          parkingType: document.get("parkingType"),
          userId: document.get("userId"));
      parkLot!.parkId=document.id;
    }
    );
    setState(() {

    });
  }
}

class OwnerParkLotInfo extends StatefulWidget {
  final ParkingModel parkingModel;
  const OwnerParkLotInfo({Key? key,required this.parkingModel}) : super(key: key);

  @override
  _OwnerParkLotInfoState createState() => _OwnerParkLotInfoState();
}

class _OwnerParkLotInfoState extends State<OwnerParkLotInfo> {

  String? Address;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentAddress(widget.parkingModel.location).then((value){
      setState(() {
        Address=value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left:10, right: 10, top: 30),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, right: 20,top:20,bottom: 20),
                child:Text(widget.parkingModel.parkName.toUpperCase()+" PARKING",
                    style: TextStyle(
                      fontFamily: 'Lobster',
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,

                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shadowColor: Colors.black,
                  elevation: 7.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Slots: ${widget.parkingModel.totalSlots}",
                            style: TextStyle(
                              fontFamily: 'Lobster',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            )),
                        SizedBox(height: 20,),
                        Text("Available Slots: ${widget.parkingModel.availableSlots}",
                            style: TextStyle(
                              fontFamily: 'Lobster',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 10, right: 20, top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, size: 30),
                    Flexible(
                      child: Text(Address!,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'Lobster',
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          )
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 15, right: 20, top: 20),
                child: Row(
                  children: [
                    Text(" \u{20B9} ${widget.parkingModel.price} per hour",
                        style: TextStyle(
                          fontFamily: 'Lobster',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.edit),
                    Text("Edit",style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
              Divider(color: Colors.black54,),
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 30,right: 30),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(10.0),

                ),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ViewParkingUsers()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Vehicles in your Parking',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              )
            ]));
  }
}

