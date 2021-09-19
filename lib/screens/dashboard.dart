import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkme/screens/RegisterParkingArea/ownerhomepage.dart';
import 'package:parkme/screens/RegisterParkingArea/registrationOwner.dart';
import 'package:parkme/screens/FindParking/homepage.dart';
import 'package:parkme/theme.dart';
import 'package:parkme/utils/UserModel.dart';
import 'package:parkme/utils/putNfetch.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  UserModel? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserInfo().then((value) {
      user = value;
      setState(() {
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (user==null)?Container():
        SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.fromLTRB(40,50,40,20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Hello ${user!.name},",style: GoogleFonts.lato(color: kPrimaryColor,fontSize: 40,fontWeight: FontWeight.bold),)),
            ),
            Container(
              height: MediaQuery.of(context).size.height*(1/2),
              child: Image(
                image: AssetImage("assets/globe.gif"),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              height:50,
              width: MediaQuery.of(context).size.width*(3/4),
              child: OutlinedButton(

                  onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage()));},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    elevation: 10,
                    shadowColor: kPrimaryColor,
                  ),
                  child: Text(
                    "Find Parking Area",
                    style: TextStyle(color: Colors.white,fontSize: 20),
                  )),
            ),
            SizedBox(height: 20,),
            TextButton(
                onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) => OwnerHomePage()));},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Manage your parking area",
                      style: TextStyle(color:kPrimaryColor,fontSize: 18),
                      textAlign: TextAlign.center,),
                    Icon(Icons.navigate_next,color: kPrimaryColor,)
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
