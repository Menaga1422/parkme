//@dart=2.9

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
              onMapCreated: (controller)=>_googleMapController=controller,
              initialCameraPosition: CameraPosition(target: LatLng(51.5074,-0.1278),zoom: 8.0),
              markers: {if(origin!=null) origin},
              onTap: (pos)=>addMarker(pos),
          ),
          Positioned(
              top: 30.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Address",
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
              )),
              Positioned(
                  top: 520.0,
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
                      onPressed: (){print(origin.position);},
                    ),
                  ))

        ],
      ),
    );
  }
  
  searchAndNavigate()
  {
      GeocodingPlatform.instance.locationFromAddress(searchAddress).then((result){
        _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(result[0].latitude,result[0].longitude),zoom: 10.0),
        ));
      });
  }
  addMarker(LatLng latlng)
  {
    setState(() {
      origin=Marker(
        markerId: MarkerId("Your location"),
        infoWindow: InfoWindow(title:"Your location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        position: latlng,
      );
      print(latlng);
    });
  }
}