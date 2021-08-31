import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:parkme/screens/registerPage.dart';
import 'package:parkme/theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme(),
      home: Register(),
    );
  }
}
