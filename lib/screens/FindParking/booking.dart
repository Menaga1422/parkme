import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkme/screens/Components/DialogBox.dart';
import 'package:parkme/screens/FindParking/homepage.dart';
import 'package:parkme/screens/FindParking/payment.dart';
import 'package:parkme/screens/FindParking/utils/fetchParkLots.dart';
import 'package:parkme/theme.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:parkme/utils/ParkingModel.dart';
import 'dart:math';


class Booking extends StatefulWidget {
  final ParkingModel parklot;
  const Booking({Key? key,required this.parklot}) : super(key: key);

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  double _height=0;
  double _width=0;

  String? _setTime="";

  String _hour="", _minute="",_settime="";

  String departtime="";
  String arrivaltime="";



  String dateTime="";

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);



  TextEditingController _arrivalTime = TextEditingController();
  TextEditingController _departTime = TextEditingController();
  TextEditingController _slotno=new TextEditingController();
  TextEditingController _vehicleno=new TextEditingController();
  TextEditingController _contactno=new TextEditingController();
  String duration="00";
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  List<bool> vehicleSelections = List.generate(2, (_)=> false);


  @override
  void initState() {
    super.initState();

    _slotno.text=(Random().nextInt(widget.parklot.availableSlots) + 1).toString();

    _arrivalTime.text = formatDate(
        DateTime(2021, 08, 1, 0, 0),
        [hh, ':', nn, " ", am]).toString();


    _departTime.text = formatDate(
        DateTime(2021, 08, 1, 0, 0),
        [hh, ':', nn, " ", am]).toString();
    

  }
  
  Future putBookingDetails()async{
    print(">>>>>>>>>>>>>${widget.parklot.parkId}");
    String userID=FirebaseAuth.instance.currentUser!.uid;
    Map<String,dynamic> bookDet={"slotNo":_slotno.text ,"vehicleNo":_vehicleno.text,"contactNo":_contactno.text,
      "vehicleType":(vehicleSelections[0])?"Two Wheeler":"Four Wheeler","arrivalTime":_arrivalTime.text,
      "duration":duration,"parkId":widget.parklot.parkId,"deptTime":_departTime.text,
    };
    FirebaseFirestore.instance..collection("Booking").doc(userID).set(bookDet);
    print(">>>>>>>>>>>>>>>>>>>>BOOKED");
    setState(() {

    });
  }



  @override
  Widget build(BuildContext context){
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    dateTime = DateFormat.yMd().format(DateTime.now());
    Timeduration();


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50,left: 10),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Text(
                  'Book Your Slot',
                  style: TextStyle(
                    fontFamily: 'Lobster',
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryColor,

                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                    controller: _slotno ,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.perm_identity_outlined,color: kPrimaryColor,),
                      hintText: 'Slot No',
                    ),
                    validator: validateno,
                  ),

                ),



                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                    controller: _vehicleno ,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.time_to_leave_rounded,color: kPrimaryColor),
                      hintText: 'Vehicle No',
                    ),
                    validator: validateno,
                  ),
                ),



                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                    controller: _contactno ,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.contact_phone_rounded,color: kPrimaryColor),
                      hintText: 'Contact No',
                    ),
                    validator: validateContact,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 25, right: 20, top: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Select your vehicle", style: TextStyle(
                          fontFamily: 'Lobster',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,)),
                        SizedBox(height: 20,),
                        ToggleButtons(
                          selectedColor: kPrimaryColor,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 25, right: 20),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                children: [
                                  Icon(Icons.two_wheeler_outlined,size: 20,),
                                  Text("Two Wheeler"),
                                ],
                              ),),
                              Container(
                                margin: EdgeInsets.only(left: 25, right: 20),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                children: [
                                  Icon(Icons.directions_car_outlined,size: 20,),
                                  Text("Four Wheeler"),
                                ],
                              ),),
                            ],
                            isSelected: vehicleSelections,
                            onPressed: (int index) {
                            setState(() {

                              vehicleSelections[index] = !vehicleSelections[index];
                              if(index==1)
                              {
                                vehicleSelections[0] = false;
                              }
                              else
                              {
                                vehicleSelections[1] = false;
                              }
                            });
                            }),
                      ],
                    ),
                  ),
                ),


                InkWell(
                  onTap: () {
                    _selectTime1(context);

                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    width: _width / 1.05,
                    height: _height / 11,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextFormField(
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.left,
                      // onSaved: (String? val) {
                      //   _setTime = val;
                      // },
                      enabled: false,

                      keyboardType: TextInputType.text,
                      controller: _arrivalTime,

                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.timer),
                        disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                        labelText: 'Arrival Time',
                        // contentPadding: EdgeInsets.all(5)
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    _selectTime2(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    width: _width / 1.05,
                    height: _height / 11,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextFormField(
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.left,
                      onSaved: (String? val) {
                        _setTime = val;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _departTime,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.timer),
                          disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                          labelText: 'Departure Time',
                          contentPadding: EdgeInsets.all(5)),
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Timeduration();

                  },
                  child:Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    height: 50,
                    width: MediaQuery.of(context).size.width/2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(0.0, 3.0),
                        blurRadius: 7.0,
                        spreadRadius: 2.0,)]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Duration ", style: TextStyle(
                          fontFamily: 'Lobster',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,)),
                        Text(duration,style: TextStyle(
                          fontFamily: 'Lobster',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,),)
                      ],
                    ),

                    ),
                  ),


                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: MaterialButton(
                    padding: EdgeInsets.only(top: 10, bottom: 10,left: 30,right: 30),
                    color: kSecondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () async {
                      if(_formkey.currentState!.validate()){
                        // print("Successful");
                        await putBookingDetails();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Pay(parklot: widget.parklot,duration: duration,)));
                        // showDialog(context: context, builder: (BuildContext context){return DialogBox(title:"Booked Successfully !!\nCheck your Booking tab");});

                      }else{
                        print("Unsuccessful");
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),

      ),
    );

  }
  Future<Null> _selectTime1(BuildContext context)  async{
    final TimeOfDay? picked =  await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _settime= _hour + ' : ' + _minute;
        _arrivalTime.text = _settime;
        _arrivalTime.text = formatDate(
            DateTime(2021, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        arrivaltime=formatDate(
            DateTime(2021, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]);
        print(_arrivalTime.text);

      });
  }

  Future<Null> _selectTime2(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _settime = _hour + ' : ' + _minute;
        _departTime.text= _settime;
        _departTime.text = formatDate(
            DateTime(2021, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        departtime=formatDate(
            DateTime(2021, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]);

      });}

  void Timeduration(){

    String h1= (_departTime.text.substring(0,2));
    int hd=int.parse(h1);

    if(_departTime.text.substring(6,7)=='A'){
      if (hd == 12) {
        // System.out.print("00");
        departtime="00"+":"+_departTime.text.substring(3,5);

      }
    }
    if(_departTime.text.substring(6,7)=='P'){
      if (hd== 12) {
        // System.out.print("00");
        // _timedept.replaceRange(0, 2, "12");
        departtime="12"+":"+_departTime.text.substring(3,5);
      }
      else{
        hd=hd+12;
        departtime=hd.toString()+":"+_departTime.text.substring(3,5);
      }
    }
    print("**"+departtime);

    String h2= (_arrivalTime.text.substring(0,2));
    int ha=int.parse(h2);

    if(_arrivalTime.text.substring(6,7)=='A'){
      if (ha == 12) {
        // System.out.print("00");
        arrivaltime="00"+":"+_arrivalTime.text.substring(3,5);

      }
    }
    if(_arrivalTime.text.substring(6,7)=='P'){
      if (ha== 12) {
        // System.out.print("00");
        // _timedept.replaceRange(0, 2, "12");
        arrivaltime="12"+":"+_arrivalTime.text.substring(3,5);
      }
      else{
        print("Enter");
        ha=ha+12;
        arrivaltime=hd.toString()+":"+_arrivalTime.text.substring(3,5);
      }
    }
    print("##"+arrivaltime);

    var format = DateFormat("HH:mm");
    var depart = format.parse(departtime);
    var arrival= format.parse(arrivaltime);
    String diff=depart.difference(arrival).toString();

    String timeduration=diff.substring(0,4);
    duration=timeduration;

  }

}
String? validateno(formText){
  if(formText.isEmpty){
    return "field is required";
  }
}

String? validateContact(formContact){
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);
  if (formContact.length == 0) {
    return "field is required";
  }
  else if (!regExp.hasMatch(formContact)) {
    return 'Please enter valid mobile number';
  }
}

