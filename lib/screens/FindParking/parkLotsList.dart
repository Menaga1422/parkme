import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkme/theme.dart';
import 'package:parkme/utils/LocationHelpers.dart';
import 'package:parkme/utils/ParkingModel.dart';

class ParkLotList extends StatefulWidget {
  final List<ParkingModel> parklots;
  const ParkLotList({Key? key,required this.parklots}) : super(key: key);

  @override
  _ParkLotListState createState() => _ParkLotListState();
}

class _ParkLotListState extends State<ParkLotList> {



  Future<String>  getAddress(int index) async{
    String Address=await getCurrentAddress(widget.parklots[index].location).then((value)=>value);
    return Address;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.parklots.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("Parkme",
          style: GoogleFonts.rochester(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10,30,10,0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Parking locations nearby",
                style: GoogleFonts.lato(
              fontWeight: FontWeight.w800,
              fontSize: 27,
              color: kPrimaryColor
          ),),
              SizedBox(height: 30,),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.parklots.length,
                itemBuilder: (BuildContext context,int index){
                return Container(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom:15.0),
                          child: Text("${widget.parklots[index].parkName} Parking",
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                color: Colors.black87
                                ),
                          )),
                      Row(
                        children: [
                          Icon(Icons.location_on,color: kSecondaryColor,),
                          FutureBuilder(
                              future: getAddress(index),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                               Text text;
                               if(snapshot.hasData)
                               {
                                 text=Text("${snapshot.data}");
                               }
                               else
                               {
                                 text=Text("loading");
                               }
                               return Container(
                                    child:text
                               );
                          },
                          )],
                      ),
                      Divider(color: Colors.black54,),
                    ],
                  ),
                );}
                ),
                ]),
        ),
      )
          );
  }
}
