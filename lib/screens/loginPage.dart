
import 'package:flutter/material.dart';
import 'package:parkme/screens/dashboard.dart';
import 'package:parkme/theme.dart';


class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  String? _userid;

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50,left: 10),
          child: Column(
            children: [

              Text(
                'ParkMe',
                style: TextStyle(
                  fontFamily: 'Lobster',
                  fontSize: 45,
                  fontWeight: FontWeight.w500,

                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                  controller: _email ,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: TextFormField(
                  controller: _password ,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                child: MaterialButton(
                  padding: EdgeInsets.only(top: 10, bottom: 10,left: 30,right: 30),
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  onPressed: () async{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(),));
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: (){

                },
                child: Text('New User? Register Now'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
