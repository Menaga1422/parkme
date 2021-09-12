//@dart=2.9

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geoCo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkme/theme.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({Key key}) : super(key: key);

  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {

  GoogleMapController _googleMapController;
  Marker origin;
  String searchAddress;
  LatLng myLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
              onMapCreated: (controller)=>_googleMapController=controller,
              initialCameraPosition: CameraPosition(target: myLocation,zoom: 8.0),
              markers: {if(origin!=null) origin},
              onTap: (pos)=>addMarker(pos),
          ),
          Positioned(
              top: 80.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: searchAddress,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0,top: 15.0),
                      suffixIcon: IconButton(
                          icon:Icon(Icons.search),
                          color: kPrimaryColor,
                          onPressed: searchAndNavigate,
                      )
                    ),
                    onChanged: (value){
                      setState(() {
                        searchAddress=value;
                      });
                    },
                  ),
                ))),
              Positioned(
                  top: 700.0,
                  right: 15.0,
                  left: 15.0,
                  child: Padding(
                    padding: EdgeInsets.only(right: 50.0),
                    child: MaterialButton(
                      elevation: 10.0,
                      height: 50.0,
                      minWidth: 200.0,
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: Text("Set Location",style: TextStyle(color: Colors.white,fontSize: 15.0),),
                      onPressed: ()async{
                        print(origin.position);
                        await getCurrentAddress();
                        Navigator.pop(context,origin.position);
                        },
                    ),
                  ))

        ],
      ),
    );
  }
  
  searchAndNavigate()
  {
    geoCo.GeocodingPlatform.instance.locationFromAddress(searchAddress).then((result){
        _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(result[0].latitude,result[0].longitude),zoom: 10.0),
        ));
      });
  }
  addMarker(LatLng latlng)
  {
    origin=Marker(
      markerId: MarkerId("Your location"),
      infoWindow: InfoWindow(title:"Your location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      position: latlng,
    );
    print(latlng);
    getCurrentAddress();
    setState(() {

    });
  }
  getCurrentLocation()async{
    try{
      await GeolocatorPlatform.instance.getCurrentPosition().then((value) {
        setState(() {
          print(value);
          myLocation= LatLng(value.latitude, value.longitude);
          print(myLocation);
          addMarker(myLocation);
      });});
    }
    catch(e)
    {
      print(e);
    }
  }
  getCurrentAddress() async
  {

    List<geoCo.Placemark> address= await geoCo.GeocodingPlatform.instance.placemarkFromCoordinates(origin.position.latitude,origin.position.longitude);
    var mainAddress=address[0];
    searchAddress=mainAddress.locality.toString();
    print(mainAddress);
    if(mainAddress!=null) {
      var MyAddress;
      MyAddress =  "${mainAddress.name}";
      MyAddress =  "$MyAddress ${mainAddress.subLocality}" ;
      MyAddress =  "$MyAddress, ${mainAddress.locality}" ;
      MyAddress =  "$MyAddress, ${mainAddress.country}" ;
      MyAddress =  "$MyAddress, ${mainAddress.postalCode}" ;

      setState(() {
        searchAddress=MyAddress;
      });
    }
  }
}
