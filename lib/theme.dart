import 'package:flutter/material.dart';



const kPrimaryColor=Color(0xff7868e6);
const kSecondaryColor=Colors.deepOrangeAccent;

ThemeData theme()
{
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Color(0xff7868E6),
    accentColor: Colors.white,
    iconTheme: IconThemeData(
      color: kPrimaryColor,
    )

  );
}