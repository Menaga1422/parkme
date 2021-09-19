// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geoCo;
import 'package:parkme/screens/FindParking/parkLotDetails.dart';
import 'package:parkme/screens/FindParking/parkLotsList.dart';
import 'package:parkme/screens/FindParking/utils/fetchParkLots.dart';
import 'package:parkme/theme.dart';
import 'package:parkme/utils/ParkingModel.dart';


class FindParking extends StatefulWidget {
  const FindParking({Key key}) : super(key: key);

  @override
  _FindParkingState createState() => _FindParkingState();
}

class _FindParkingState extends State<FindParking> {



  GoogleMapController _googleMapController;
  LatLng myLocation;
  CameraPosition _cameraPosition=CameraPosition(target: LatLng(0, 0),zoom: 12.0);
  String myAddress="Searching..";
  TextEditingController searchAddress=TextEditingController();
  List<Marker> markers=[];
  BitmapDescriptor icon;
  List<ParkingModel> nearbyParkLots=[];

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
     super.initState();

    _cameraPosition=CameraPosition(target: LatLng(0, 0),zoom: 12.0);
    setMarkerImage();
    getLocationPermission();
    getCurrentLocation();

  }

  setMarkerImage() async{
    icon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(size:Size(12,12)),
        'assets/car.png');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: Container(child:Text("PArking location near YOu")),
      appBar: AppBar(
        title: Text("Parkme",
          style: GoogleFonts.rochester(
              fontSize: 30,
              color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: (myLocation!=null)?Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition:_cameraPosition,
            onMapCreated: (GoogleMapController controller)=>_googleMapController=controller,
            markers: Set.from(markers),

          ),
          Positioned(
              top: 10.0,
              right: 15.0,
              left: 15.0,
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex:4,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: searchAddress,
                          decoration: InputDecoration(
                              hintText: "Where you wanna go?",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 15.0,top: 15.0),
                              suffixIcon: IconButton(
                                icon:Icon(Icons.search),
                                color: kPrimaryColor,
                                onPressed: searchAndNavigate,
                              )
                          ),
                        )),
                  ),
                    Expanded(
                      flex: 1,
                      child: IconButton(icon: Icon(Icons.segment,size: 30), onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>ParkLotList(parklots: nearbyParkLots)));
                      }),
                    )
                ],
              )),
        ],
      ):
      Container(

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
  }

  getCurrentLocation()async{
    try{
      await GeolocatorPlatform.instance.getCurrentPosition().then((value) {
        setState(() {
          print(value);
          myLocation= LatLng(value.latitude, value.longitude);
          print(myLocation);
          _cameraPosition=CameraPosition(target:myLocation,zoom: 12.0 );
          print(_cameraPosition);
          if(_googleMapController!=null)
          _googleMapController.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));

        });
      });
      setMarkers(myLocation);
      getCurrentAddress();
      fetchParkLots();
    }
    catch(e)
    {
      print(e);
    }
  }

  getCurrentAddress() async
  {

    List<geoCo.Placemark> address= await geoCo.GeocodingPlatform.instance.placemarkFromCoordinates(myLocation.latitude,myLocation.longitude);
    var mainAddress=address[0];
    myAddress=mainAddress.locality.toString();
    print(mainAddress);
    if(mainAddress!=null) {
      var MyAddress;
      MyAddress =  "${mainAddress.name}";
      MyAddress =  "$MyAddress ${mainAddress.subLocality}" ;
      MyAddress =  "$MyAddress, ${mainAddress.locality}" ;
      MyAddress =  "$MyAddress, ${mainAddress.country}" ;
      MyAddress =  "$MyAddress, ${mainAddress.postalCode}" ;

      setState(() {
        myAddress=MyAddress;
      });
    }
  }


  fetchParkLots() async{
    print(">>>>>>>>Fetch");
    final QuerySnapshot result = await FirebaseFirestore.instance.collection("parkLot").get();
    final List<QueryDocumentSnapshot<Object>> document = result.docs;
    document.forEach((element) async {
      LatLng parkLoc=LatLng(element["location"].latitude,element["location"].longitude);
      print(distanceBetweenUsers(myLocation,parkLoc));
      print(">>>>>>>>>>>>>>>>>>>"+element.id+">>>>>"+element.get("parkName"));
      ParkingModel parkLot=ParkingModel(parkName: element.get("parkName"),
          contactNumber: element.get("parkName"),
          location: LatLng(element["location"].latitude,element["location"].longitude),
          price: element.get("price"),
          totalSlots: element.get("totalSlots"),
          availableSlots: element.get("availableSlots"),
          parkingType: element.get("parkingType"),
          userId: element.get("userId"));
      parkLot.parkId=element.id;
      updateMarkers(parkLot, element.id);
      setState(() {
        print(">>>>>>>>>>>>>>>>>>>>>$nearbyParkLots");
        nearbyParkLots.add(parkLot);
      });
        }
    );
  }

  searchAndNavigate()async
  {
     geoCo.GeocodingPlatform.instance.locationFromAddress(searchAddress.text).then((result){
       print(result[0].toString());
       setState(() {
         _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
           CameraPosition(target: LatLng(result[0].latitude,result[0].longitude),zoom: 12.0),
         ));
      });
    });
  }
  setMarkers(LatLng location)
  {
      markers.add(Marker(markerId: MarkerId("My location"),
          infoWindow: InfoWindow(title: "My location"),
          onTap: (){
            print("Marker tapped");
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          position: location));
  }
  updateMarkers(ParkingModel parkLot,String id) async {
    print(">>>>>>>>>>>Updatemarkers");
    markers.add(Marker(markerId: MarkerId(id),
        onTap: (){
          print("Parking Marker tapped");
          showModalBottomSheet(context: context,
              builder: (BuildContext context)=>ParkLotInfo(parkingModel: parkLot,),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))
          );

        },
        icon:icon,
        infoWindow:InfoWindow(
          title: parkLot.parkName,
        ) ,
        position: parkLot.location));
    setState(() {

    });
  }
}
