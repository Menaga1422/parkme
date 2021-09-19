import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<String> getCurrentAddress(LatLng location) async
{

  List<Placemark> address= await GeocodingPlatform.instance.placemarkFromCoordinates(location.latitude,location.longitude);
  var mainAddress=address[0];
  print(mainAddress);
  var MyAddress;
  MyAddress =  "${mainAddress.name}";
  MyAddress =  "$MyAddress ${mainAddress.subLocality}" ;
  MyAddress =  "$MyAddress, ${mainAddress.locality}" ;
  MyAddress =  "$MyAddress, ${mainAddress.country}" ;
  MyAddress =  "$MyAddress, ${mainAddress.postalCode}" ;

  return MyAddress;
}