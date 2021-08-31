import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkme/theme.dart';
import 'package:parkme/screens/loginPage.dart';
import 'package:parkme/utils/registerUser.dart';

class Register extends StatefulWidget{
  const Register({Key? key}) : super(key: key);
  RegisterState createState()=>RegisterState();
}

class RegisterState extends State<Register>{
  
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();
  TextEditingController _name= new TextEditingController();
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50,left: 10),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontFamily: 'Lobster',
                      fontSize: 40,
                      fontWeight: FontWeight.w500,

                    ),
                  ),
                ),
                SizedBox(height: 35,),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                    controller: _name ,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Name',
                    ),
                    validator: (name)
                    {
                      if(name!.isEmpty)
                        {
                          return 'Name cant be empty';
                        }
                    },
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
                    validator: (email)=>validateEmail(email),
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
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: TextFormField(
                    controller: _confirmPassword ,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Confirm Password',
                    ),
                    validator: (value){
                      return _password.text==value?null:"Passwords don't match.";
                    },
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
                    onPressed: (){
                      if(_formkey.currentState!.validate())
                        {
                          print("Form is valid");

                        }
                      else
                        {
                          print("Form is not Valid");
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
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn(),));
                  },
                  child: Text('Already have an account? Login'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
String? validateText(formText){
  if(formText.isEmpty){
    return "Field is required.";
  }
  return null;
}
String? validateEmail(formEmail){
  if(formEmail.isEmpty){
    return "E-mail address is required.";
  }
  String pattern=r'\w+@\w+\.\w+';
  RegExp regex=RegExp(pattern);
  if(!regex.hasMatch(formEmail)){
    return "Invalid E-mail";
  }
  return null;
}