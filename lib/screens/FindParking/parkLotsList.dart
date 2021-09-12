import 'package:flutter/material.dart';
import 'package:parkme/theme.dart';
import 'package:parkme/utils/ParkingModel.dart';

class ParkLotList extends StatefulWidget {
  final List<ParkingModel> parklots;
  const ParkLotList({Key? key,required this.parklots}) : super(key: key);

  @override
  _ParkLotListState createState() => _ParkLotListState();
}

class _ParkLotListState extends State<ParkLotList> {
  @override
  Widget build(BuildContext context) {
    print(widget.parklots.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("ParkMe"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10,30,10,0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Parking locations nearby",style: TextStyle(color: kPrimaryColor,fontSize: 25,fontWeight: FontWeight.w500),),
              SizedBox(height: 30,),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.parklots.length,
                itemBuilder: (BuildContext context,int index){
                return Card(
                elevation: 8.0,
                shadowColor: Colors.grey,
                child: Container(
                  padding: EdgeInsets.all(15.0),
                    height: 100,
                    child: Text("${widget.parklots[index].parkName} Parking",
                      style: TextStyle(
                        fontFamily: 'Lobster',
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    )),
                );}
                ),
                ]),
        ),
      )
          );
  }
}
