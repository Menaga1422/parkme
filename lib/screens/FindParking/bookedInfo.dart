import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkme/screens/Components/Timer.dart';

class BookedInfo extends StatefulWidget {
  const BookedInfo({Key? key}) : super(key: key);

  @override
  _BookedInfoState createState() => _BookedInfoState();
}

class _BookedInfoState extends State<BookedInfo> {

  String? parkName;
  Map<String, dynamic>? bookedDetails;


  getBookedDetails()async{
    String userId=FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("Booking").doc(userId)
            .get()
            .then((value) async {
              bookedDetails=value.data();
              await FirebaseFirestore.instance.collection("parkLot").doc(bookedDetails!["parkId"]).get().then((value) =>parkName=value.get("parkName") );
    });
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookedDetails();
  }

  @override
  Widget build(BuildContext context) {
    if(bookedDetails==null)
      {
        return Container();
      }
    return Scaffold(
      appBar: AppBar(
        title: Text("ParkMe"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            height: MediaQuery.of(context).size.height/2,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20,50,20,20),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,5),
                blurRadius: 5
          )],),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$parkName Parking",
                  style: TextStyle(
                      fontFamily: 'Lobster',
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                  ),
              ),
              SizedBox(height: 20,),
              Text("Arrival time: ${bookedDetails!["arrivalTime"]} ",style: TextStyle(fontSize: 20),),
              SizedBox(height: 10,),
              Text("Booked duration: ${bookedDetails!["duration"]} ",style: TextStyle(fontSize: 20),),
              SizedBox(height: 50,),
              Center(
                child: Text("Booking will expire in ",
                  style: TextStyle(
                    fontFamily: 'Lobster',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Center(child: Container(child: Timer(levelClock: 1500,),)),
            ],
          )),
        ),
      ));
  }
}
