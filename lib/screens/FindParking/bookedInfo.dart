import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkme/screens/Components/CustomTimer.dart';
import 'package:intl/intl.dart';
import 'package:parkme/screens/FindParking/utils/fetchParkLots.dart';

import '../../main.dart';
import '../../theme.dart';

class BookedInfo extends StatefulWidget {
  const BookedInfo({Key? key}) : super(key: key);

  @override
  _BookedInfoState createState() => _BookedInfoState();
}

class _BookedInfoState extends State<BookedInfo> {

  String? parkName;
  Map<String, dynamic>? bookedDetails;
  int remTime=0;
  String? deptTime;
  String? arrivalTime;
  int? duration;

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
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookedDetails();
    convertTime();
    calcExpiryTime();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
    // print(duration);

  }

  void showNotification()async {
    timer=await Future.delayed(Duration(seconds:2), () {
    flutterLocalNotificationsPlugin.show(
        0,
        "Parkme",
        "Pick your car from your parking area",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher'))
    );});
  }
  DateTime? at,dt;
  Future convertTime() async{
    String userID=FirebaseAuth.instance.currentUser!.uid;
    // String arrivalTime= await FirebaseFirestore.instance.collection("Booking").doc(userID).get()
    //     .then((value) => value.get("arrivalTime"));
    // // String deptTime= await FirebaseFirestore.instance.collection("Booking").doc(userID).get()
    // //     .then((value) => value.get("deptTime"));

    String durationTime= await FirebaseFirestore.instance.collection("Booking").doc(userID).get()
        .then((value) => value.get("duration"));
    int hrs = int.parse(durationTime.substring(0,1));
    int mins = hrs+(int.parse(durationTime.substring(2,4)));

    // var df =  DateFormat("h:mm a");
    // var d1 = df.parse(arrivalTime); //change to arrival time
    // var d2 = df.parse(deptTime);
    // String t1=DateFormat('HH:mm').format(d1);
    // String t2=DateFormat('HH:mm').format(d2);
    // at=DateFormat('HH:mm').parse(t1);
    // dt=DateFormat('HH:mm').parse(t2);
    setState(() {
      duration=mins*60;
    });
    print(">>>>>>>>>>>>>>>>>>"+duration.toString());
  }

  Future calcExpiryTime() async
  {
    String userID=FirebaseAuth.instance.currentUser!.uid;
    String arrivalTime= await FirebaseFirestore.instance.collection("Booking").doc(userID).get()
        .then((value) => value.get("arrivalTime"));

    DateTime currentTime=DateTime.now();
    var df =  DateFormat("h:mm a");
    var d = df.parse(arrivalTime); //change to arrival time
    var dateFormat = DateFormat("yyyy-MM-dd");
    String updatedDt = dateFormat.format(currentTime);
    String t=updatedDt+" "+DateFormat('HH:mm').format(d);
    DateTime at=DateFormat('yyyy-MM-dd HH:mm').parse(t);
    print(">>>>>>>>>>>"+at.toString());
    setState(() {
      remTime=at.difference(currentTime).inSeconds;
    });
    print(remTime);
  }

  @override
  Widget build(BuildContext context) {
    if(bookedDetails==null)
      {
        return Container();
      }
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: showNotification,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text("Your Bookings",style: GoogleFonts.lato(color: Colors.black54,fontSize: 35,fontWeight: FontWeight.w700),)),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                            color: kSecondaryColor,
                        ),
                    ),
                    SizedBox(height: 20,),
                    Text("Arrival time: ${bookedDetails!["arrivalTime"]} ",style: TextStyle(fontSize: 20),),
                    SizedBox(height: 10,),
                    Text("Booked duration: ${bookedDetails!["duration"]} ",style: TextStyle(fontSize: 20),),
                    SizedBox(height: 50,),
                    (remTime > 0)?
                    Column(
                      children: [
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
                        Center(child: Container(child: CustomTimer(),))
                      ],
                    )
                    :Center(
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            border: Border.all(
                            color: Colors.black,
                      ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                        child: Center(
                          child: Text("Booking expired",
                            style: TextStyle(
                              fontFamily: 'Lobster',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: kSecondaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )

                  ],
                )),
              ),
            ],
          ),
        ),
      ));
  }
}
