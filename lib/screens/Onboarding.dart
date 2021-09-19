import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkme/screens/loginPage.dart';
import 'package:parkme/theme.dart';

import '../main.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final List<Map<String, String>> splashData = [
    {
      "title": "Find Parking Lots ",
      "subtitle":
      "Book your Parking area beforehand and have a happy outing ",
      "image": "https://image.freepik.com/free-vector/man-with-map-smartphone-renting-car-driver-using-car-sharing-app-phone-searching-vehicle-vector-illustration-transport-transportation-urban-traffic-location-app-concept_74855-10109.jpg"
    },
    {
      "title": "Find your car",
      "subtitle":
      "Cant remember where you parked your car?Track it in our app",
      "image": "https://image.freepik.com/free-vector/parking-concept-illustration_114360-6554.jpg"
    },
    {
      "title": "Register your parking area",
      "subtitle":
      "Do you wanna earn money by renting your unused area for parking? Do it by a click",
      "image": "https://image.freepik.com/free-vector/suburban-buildings-isometric-illustration-with-private-townhouse-two-family-with-isolated-inputs-car-house-territory_1284-57057.jpg"
    },
  ];

  AnimatedContainer _buildDots({index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: const Color(0xFF293241),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: showNotification,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _controller,
                itemCount: splashData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        Text("Parkme",
                          style: GoogleFonts.rochester(
                              fontSize: 45,
                              fontWeight: FontWeight.w500,
                              color: kPrimaryColor
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:30,bottom: 15.0),
                          child: Text(
                            splashData[index]['title']!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: kPrimaryColor,
                            )
                          ),
                        ),
                        Text(
                          splashData[index]['subtitle']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.5,
                          )
                        ),
                        Spacer(
                          flex: 2,
                        ),
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            splashData[index]['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  );
                },
                onPageChanged: (value) => setState(() => _currentPage = value),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                            (int index) => _buildDots(index: index),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        onPressed: () {
                          (_currentPage + 1 == splashData.length)?Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogIn())):
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                          );
                        },
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: kSecondaryColor,
                            textStyle: GoogleFonts.lato( fontSize: 20,
                              fontWeight: FontWeight.w400,)),
                        child: Text(
                          _currentPage + 1 == splashData.length
                              ? 'Get Started'
                              : 'Continue',
                          // style: TextStyle(
                          //   fontFamily: 'Lobster',
                          //   fontSize: 20,
                          //   fontWeight: FontWeight.w400,
                          // ),
                        ),

                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}