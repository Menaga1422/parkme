
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'UserModel.dart';

Future putUserInfo(UserModel user) async{
  String userId= FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> userData= {"userName":user.name,"email":user.email};
  await FirebaseFirestore.instance.collection("users").doc(userId).set(userData);
  print(">>>>>>>>>>>>>>UserDetailsInserted");
}

Future<UserModel> fetchUserInfo()async{
  Map<String, dynamic>? userData;
  String userId= FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance.collection("users").doc(userId).get()
      .then((value) => userData=value.data());
  print(">>>>>>>>>>>>>>>>>User fetched"+userData!.toString());

  //-----Set User----//
  UserModel user=UserModel();
  user.userid=userId;
  user.name=userData!["userName"];
  user.email=userData!["email"];
  return user;
}