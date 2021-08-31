import 'package:flutter/material.dart';
import 'package:parkme/screens/homepage.dart';
import 'package:parkme/theme.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30,),
            Container(
              height: MediaQuery.of(context).size.height*(1/2),
              child: Image(
                image: AssetImage("assets/globe.gif"),
              ),
            ),
            SizedBox(height: 100,),
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
                onPressed: (){},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Register your parking area",
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
