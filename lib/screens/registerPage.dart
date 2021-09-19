import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkme/screens/dashboard.dart';
import 'package:parkme/theme.dart';
import 'package:parkme/screens/loginPage.dart';
import 'package:parkme/utils/AuthenticationHelper.dart';
import 'package:parkme/utils/UserModel.dart';
import 'package:parkme/utils/putNfetch.dart';


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

  UserModel setUser()
  {
    UserModel user=UserModel();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final userid = auth.currentUser!.uid;
    print(">>>>>>>>>>>>>"+userid);
    user.userid=userid;
    user.name=_name.text;
    user.email=_email.text;
    print(user);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            margin: EdgeInsets.only(top: 100,left: 10),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.lato(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                        // fontStyle: FontStyle.italic,
                        color: kPrimaryColor
                      )
                    ),
                  ),
                  SizedBox(height: 65,),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: TextFormField(
                      controller: _name ,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person,color: Theme.of(context).iconTheme.color),
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
                        prefixIcon: Icon(Icons.email,color: Theme.of(context).iconTheme.color,),
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
                        prefixIcon: Icon(Icons.lock,color: Theme.of(context).iconTheme.color),
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
                        prefixIcon: Icon(Icons.lock,color: Theme.of(context).iconTheme.color),
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
                      color: kSecondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      onPressed: (){
                        if(_formkey.currentState!.validate())
                          {
                            print("Form is valid");
                            AuthenticationHelper()
                              .signUp(email: _email.text, password: _password.text)
                              .then((result) {
                          if (result == null) {
                            UserModel user= setUser();
                            putUserInfo(user);
                            Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Dashboard()));
                          }
                          else
                            {
                              print("Registeration Unsuccessful");
                            }
                          });
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
                    child: Text('Already have an account? Login',style: TextStyle(color: kPrimaryColor,fontSize: 15),),
                  )
                ],
              ),
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

