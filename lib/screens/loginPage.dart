
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkme/screens/dashboard.dart';
import 'package:parkme/screens/registerPage.dart';
import 'package:parkme/theme.dart';
import 'package:parkme/utils/AuthenticationHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkme/utils/UserModel.dart';


class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {


  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 200,left: 10),
          child: Column(
            children: [
              Text(
                'Parkme',
                style: GoogleFonts.rochester(
                    fontSize: 55,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryColor
                ),
              ),
              SizedBox(height: 100,),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                  controller: _email ,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person,color: Theme.of(context).iconTheme.color),
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
                    prefixIcon: Icon(Icons.lock,color: Theme.of(context).iconTheme.color),
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(height:30),
              Container(
                margin: EdgeInsets.only(top: 25),
                child: MaterialButton(
                  elevation: 10.0,
                  padding: EdgeInsets.only(top: 10, bottom: 10,left: 30,right: 30),
                  color: kSecondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  onPressed: () async{
                    AuthenticationHelper()
                        .signIn(email: _email.text, password: _password.text)
                        .then((result) {
                    if (result == null) {
                      print(">>>>>>>>>>>>>>>Logged In");
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final User? user = auth.currentUser;

                      UserModel? _user=UserModel();
                      _user.userid=user!.uid;
                      print(">>>>>>>>>>>>>>>user: "+ _user.userid);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard(),));
                    }}
                  );},
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Register(),));
                },
                child: Text('New User? Register Now',style: TextStyle(color: kPrimaryColor),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
