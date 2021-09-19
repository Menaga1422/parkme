import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme.dart';

class ViewParkingUsers extends StatefulWidget {
  const ViewParkingUsers({Key? key}) : super(key: key);

  @override
  _ViewParkingUsersState createState() => _ViewParkingUsersState();
}

class _ViewParkingUsersState extends State<ViewParkingUsers> {


  List<Customer> parkingUsers=[];

  Future fetchUsers()async{
    String userId=FirebaseAuth.instance.currentUser!.uid;
    String parkId=await FirebaseFirestore.instance.collection("parkLot").where("userId",isEqualTo:userId )
    .get().then((value) => value.docs.first.id);
    print(">>>>>>>>>>>>>>>>"+parkId);
    await FirebaseFirestore.instance.collection("Booking").where("parkId",isEqualTo: parkId)
        .get().then((value) => value.docs.forEach((element) {
          print(">>>>>>>>>>>>>>>>>>>>>>>"+element.id);
          Customer customer=Customer(element.get("slotNo"),element.get("vehicleNo"),element.get("vehicleType"));
          parkingUsers.add(customer);
    }));

    setState(() {

    });
    print(">>>>>>>>>>>>>>>>>>>"+parkingUsers.length.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsers().whenComplete(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Parkme",
            style: GoogleFonts.rochester(
                fontSize: 35,
                fontWeight: FontWeight.w500,
                color: Colors.white
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10,30,10,0),
          child: SingleChildScrollView(
            child: Column(
                children: [
                  SizedBox(height: 30,),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: parkingUsers.length,
                      itemBuilder: (BuildContext context,int index){
                        return Column(
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(15,15,20,15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text("Slot no",style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                            color: Colors.black54
                                        ),),
                                        Container(
                                          height: 70,
                                          width: 80,
                                          child: Card(
                                            elevation: 10,
                                            child:Center(
                                              child: Text("${parkingUsers.elementAt(index).slot}",
                                                style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 22,
                                                  color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment : CrossAxisAlignment.start,
                                      children: [
                                        Text("Vehicle Number:  ${parkingUsers.elementAt(index).vehicleNo}",style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                            color: Colors.black54
                                        ),),
                                        SizedBox(height: 12,),
                                        Text("Vehicle Type:  ${parkingUsers.elementAt(index).vehicleType}",style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                            color: Colors.black54
                                        ),)
                                      ],
                                    )
                                  ],
                                )),
                            Divider(color: Colors.black54,)
                          ],
                        );}
                  ),
                ]),
          ),
        )
    );
  }
}

class Customer {
  String slot;
  String vehicleType;
  String vehicleNo;

  Customer(this.slot, this.vehicleNo,this.vehicleType);

}