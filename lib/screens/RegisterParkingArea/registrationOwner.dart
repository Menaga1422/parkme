import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkme/screens/Components/DialogBox.dart';
import 'package:parkme/screens/RegisterParkingArea/ownerhomepage.dart';
import 'package:parkme/screens/RegisterParkingArea/searchLocation.dart';
import 'package:parkme/theme.dart';
import 'package:parkme/utils/AddParkingLot.dart';
import 'package:parkme/utils/ParkingModel.dart';
import 'package:geocoding/geocoding.dart';




class RegisterOwner extends StatefulWidget{
  final String parkType;
  const RegisterOwner({Key? key,required this.parkType}) : super(key: key);
  RegisterOwnerState createState()=>RegisterOwnerState(parkType: this.parkType);
}
class RegisterOwnerState extends State {
  String parkType;
  RegisterOwnerState({required this.parkType});

  TextEditingController _parkingName = new TextEditingController();
  TextEditingController _contactNumber = new TextEditingController();
  TextEditingController _slots = new TextEditingController();
  TextEditingController _price = new TextEditingController();

  LatLng? location;
  String? Address;
  String? valuechoose;
  List listItem = ["Commercial", "Private"];

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  ParkingModel setParkLot() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    ParkingModel parkLot = new ParkingModel(parkName: _parkingName.text,
        contactNumber: _contactNumber.text,
        location: location!,
        price: int.parse(_price.text),
        totalSlots: int.parse(_slots.text),
        availableSlots:int.parse(_slots.text),
        parkingType: parkType,
        userId: userId);
    return parkLot;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50, left: 10),
          child: Form(
            key: _formkey,
            child: Column(

              children: [
                SizedBox(height: 30,),
                Text(
                  'Owners Registration',
                  style: TextStyle(
                    fontFamily: 'Lobster',
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(height: 50,),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                    controller: _parkingName,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.local_parking, color: Theme
                          .of(context)
                          .iconTheme
                          .color),
                      hintText: 'ParkLot Name',
                    ),
                    validator: validateText,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                    controller: _contactNumber,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.contact_phone, color: Theme
                          .of(context)
                          .iconTheme
                          .color),
                      hintText: 'Enter Contact Number',
                    ),
                    validator: validateText,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: TextFormField(
                    controller: _slots,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.countertops, color: Theme
                          .of(context)
                          .iconTheme
                          .color),
                      hintText: 'Total Number Of Parking Slots',
                    ),
                    validator: validateText,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: TextFormField(
                    controller: _price,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                          Icons.account_balance_wallet_outlined, color: Theme
                          .of(context)
                          .iconTheme
                          .color),
                      hintText: 'Price per hour. ',
                    ),
                    validator: validateText,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    LatLng loc = await Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => SearchLocation()));
                    print(">>>>>>>>>>>>" + loc.toString());
                    setState(() {
                      location = loc;
                    });
                    await getCurrentAddress();

                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(20),
                      color: kPrimaryColor,
                      // shape: BoxShape.rectangle
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.location_on_rounded,
                              color: Colors.white,),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  (Address == null) ? "Set Location" : Address!,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Icon(Icons.navigate_next_outlined,
                              color: Colors.white,)
                          ]
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2,
                  margin: EdgeInsets.only(top: 25),
                  child: MaterialButton(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 30, right: 30),
                    color: kSecondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        print("Register Form valid");
                        ParkingModel parkLot = setParkLot();
                        putParkingInfo(parkLot);
                        showDialog(context: context, builder: (BuildContext context){return DialogBox(title:"Parking Area Registered");});
                        Future.delayed(Duration(seconds: 50), () {
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>OwnerHomePage()));
                        });


                      } else {
                        print("Register Form not valid");
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // TextButton(
                //   onPressed: (){
                //     // Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn(),));
                //   },
                //   child: Text('Already have an account? Login'),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getCurrentAddress() async
  {
    List<Placemark> address = await GeocodingPlatform.instance
        .placemarkFromCoordinates(location!.latitude, location!.longitude);
    var mainAddress = address[0];
    print(mainAddress);
    if (mainAddress != null) {
      var MyAddress;
      MyAddress = "${mainAddress.name}";
      MyAddress = "$MyAddress ${mainAddress.subLocality}";
      MyAddress = "$MyAddress, ${mainAddress.locality}";
      MyAddress = "$MyAddress, ${mainAddress.country}";
      MyAddress = "$MyAddress, ${mainAddress.postalCode}";

      setState(() {
        Address = MyAddress;
      });
    }
  }

  String? validateText(formText) {
    if (formText.isEmpty) {
      return "field is required";
    }
    // return null;
  }

  String? validateEmail(formEmail) {
    if (formEmail.isEmpty) {
      return "E-mail address is required.";
    }
    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) {
      return "Invalid E-mail";
    }
    // return null;
  }
}
