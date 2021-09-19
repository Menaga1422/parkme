import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkme/screens/RegisterParkingArea/registrationOwner.dart';
import 'package:parkme/theme.dart';


class Compri extends StatefulWidget {
  const Compri({Key? key}) : super(key: key);

  @override
  CompriState createState() => CompriState();
}

class CompriState extends State<Compri>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parkme",
          style: GoogleFonts.rochester(
              fontSize: 35,
              fontWeight: FontWeight.w500,
              color: kPrimaryColor
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        backwardsCompatibility: false,
      ),
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 0,left: 10),
          child: Column(
            children: [
              Stack(
                children: [
                  IconButton(
                    // icon: Image.network("https://i.pinimg.com/236x/4f/28/db/4f28dbc52164e7b92872241d9dd808bb--garage-lift-car-garage.jpg"),
                    icon: Image.asset('assets/images/private.jpg',width: MediaQuery.of(context).size.width,),
                    iconSize: 300,
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>RegisterOwner(parkType: "Commercial"),));
                    },
                  ),
                  Positioned(
                    top: 250,
                    left: 8,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: kPrimaryColor.withOpacity(0.5),
                      child: Text(
                        'Private',
                        style: GoogleFonts.lato(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )
                      ),
                    ),
                  ),
                  ]),
                  Stack(
                    children: [
                      IconButton(
                        // icon: Image.network("https://avtotachki.com/wp-content/uploads/2021/01/2017-10-22_19-10-02.6u2yf-999x425.jpg"),
                        icon: Image.asset('assets/images/commercial.png',),
                        iconSize: 300,
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterOwner(parkType: "Commercial",),));
                        },
                      ),
                      Positioned(
                        top: 230,
                        left: 20,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: kPrimaryColor.withOpacity(0.5),
                          child: Text(
                            'Commercial',
                              style: GoogleFonts.lato(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )
                          ),
                        ),
                      ),

                      ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}