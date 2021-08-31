// @dart=2.9
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geoCo;


class FindParking extends StatefulWidget {
  const FindParking({Key key}) : super(key: key);

  @override
  _FindParkingState createState() => _FindParkingState();
}

class _FindParkingState extends State<FindParking> {



  GoogleMapController _googleMapController;
  LatLng latlong=null;
  CameraPosition _cameraPosition=CameraPosition(target: LatLng(0, 0),zoom: 10.0);
  String myAddress="Searching..";
  List<Marker> markers=[];

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
     super.initState();

    _cameraPosition=CameraPosition(target: LatLng(0, 0),zoom: 10.0);
    getLocationPermission();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(myAddress),
      ),
      body: (latlong!=null)?GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition:_cameraPosition,
        onMapCreated: (GoogleMapController controller)=>_googleMapController=controller,
        markers: Set.from(markers),
      ):Container(

      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: ()=>_googleMapController.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition)),
        child: Icon(Icons.center_focus_strong),
      ),
      );
  }

  Future getLocationPermission() async{

    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('permission denied');
      }
    }
    getCurrentLocation();
  }

  getCurrentLocation()async{
    try{
      await GeolocatorPlatform.instance.getCurrentPosition().then((value) {
        setState(() {
          print(value);
          latlong= LatLng(value.latitude, value.longitude);
          print(latlong);
          _cameraPosition=CameraPosition(target:latlong,zoom: 10.0 );
          print(_cameraPosition);
          if(_googleMapController!=null)
          _googleMapController.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));

        });
      });
      setMarkers();
      getCurrentAddress();
    }
    catch(e)
    {
      print(e);
    }
  }

  getCurrentAddress() async
  {

    List<geoCo.Placemark> address= await geoCo.GeocodingPlatform.instance.placemarkFromCoordinates(latlong.latitude,latlong.longitude);
    var mainAddress=address[0];
    myAddress=mainAddress.locality.toString();
    print(mainAddress);
    if(mainAddress!=null) {
      var MyAddress;
      MyAddress =  "${mainAddress.subLocality}" ;
      MyAddress =  "$MyAddress,${mainAddress.locality}" ;
      MyAddress =  "$MyAddress,${mainAddress.country}" ;
      MyAddress =  "$MyAddress,${mainAddress.postalCode}" ;

      setState(() {
        myAddress=MyAddress;
      });
    }
  }

  setMarkers()
  {
    if(_cameraPosition!=null)
    {
      markers.add(Marker(markerId: MarkerId("My location"),
          onTap: (){
            print("Marker tapped");
          },
          position: latlong));
    }
  }
}
