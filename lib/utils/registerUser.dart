import 'package:firebase_auth/firebase_auth.dart';


registerUser(String userEmail,String userPassword) async{
  User? user;
  try {
    print(userEmail+" "+userPassword);
    user=(await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userEmail,
      password: userPassword,
    )).user;

  }
  catch (e) {
    print(e);

  }
  return user;
}