import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkme/screens/FindParking/booking.dart';
import 'package:parkme/utils/LocationHelpers.dart';
import 'package:parkme/utils/ParkingModel.dart';

import '../../theme.dart';

class ParkLotInfo extends StatefulWidget {
  final ParkingModel parkingModel;
  const ParkLotInfo({Key? key,required this.parkingModel}) : super(key: key);

  @override
  _ParkLotInfoState createState() => _ParkLotInfoState();
}

class _ParkLotInfoState extends State<ParkLotInfo> {

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
                margin: EdgeInsets.only(left: 15, right: 20,top:20,bottom: 10),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.parkingModel.parkName.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Lobster',
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: kPrimaryColor,

                        )
                    ),
                    Text("${widget.parkingModel.parkingType} Parking",
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.black54
                        )
                    ),
                  ],
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
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
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
              Row(
                children: [
                  Expanded(
                    flex:2,
                    child: Container(
                      margin: EdgeInsets.only(left: 10,),
                      child: MaterialButton(
                        padding: EdgeInsets.only(top: 10, bottom: 10,left: 30,right: 30),
                        color: kSecondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: (){

                        },
                        child: Text(
                          'Navigate',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex:2,
                    child: Container(
                      margin: EdgeInsets.only(left: 10,),
                      child: MaterialButton(
                        padding: EdgeInsets.only(top: 10, bottom: 10,left: 30,right: 30),
                        color: kSecondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Booking(parklot: widget.parkingModel,)));
                        },
                        child: Text(
                          'Book',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]));
  }
}

