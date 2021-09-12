import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkme/screens/FindParking/parkLotDetails.dart';
import 'package:parkme/screens/FindParking/profile.dart';
import 'package:parkme/screens/RegisterParkingArea/registrationOwner.dart';
import 'package:parkme/screens/RegisterParkingArea/selectParkType.dart';
import 'package:parkme/screens/RegisterParkingArea/viewParking.dart';
import 'package:parkme/theme.dart';
import 'package:parkme/utils/ParkingModel.dart';

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({Key? key}) : super(key: key);

  @override
  _OwnerHomePageState createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {

  int _selectedIndex=0;
  var tabs=[
    ViewParking(),
    Compri(),
    Profile(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: tabs.elementAt(_selectedIndex),
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Container(
          color: kPrimaryColor,
          padding: EdgeInsets.all(8),
          child: FloatingActionButton(
            child: Icon(Icons.add,),
            onPressed: () {
              print("Button pressed");
              Navigator.push(context,MaterialPageRoute(builder: (context)=>Compri()));
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: kPrimaryColor,
            )]
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home,size: 30,color: Colors.white,),
                onPressed: () {setState(() {
                  _selectedIndex=0;
                });},
              ),
              IconButton(
                icon: Icon(Icons.account_circle_sharp,size: 30,color: Colors.white,),
                onPressed: () {setState(() {
                  _selectedIndex=2;
                });},
              )
            ],
          ),
        ),
      ),
      );
  }
}
