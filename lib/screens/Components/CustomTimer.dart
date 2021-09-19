import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkme/theme.dart';
import 'package:intl/intl.dart';

class CustomTimer extends StatefulWidget {
  const CustomTimer({Key? key}) : super(key: key);

  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> with SingleTickerProviderStateMixin {

  AnimationController? _controller;
  DateTime currentTime=DateTime.now();
  int levelClock=0;

  Future calcExpiryTime() async
  {
    String userID=FirebaseAuth.instance.currentUser!.uid;
    String arrivalTime= await FirebaseFirestore.instance.collection("Booking").doc(userID).get()
        .then((value) => value.get("arrivalTime"));

    var df =  DateFormat("h:mm a");
    var d = df.parse(arrivalTime); //change to arrival time
    var dateFormat = DateFormat("yyyy-MM-dd");
    String updatedDt = dateFormat.format(currentTime);
    String t=updatedDt+" "+DateFormat('HH:mm').format(d);
    DateTime at=DateFormat('yyyy-MM-dd HH:mm').parse(t);
    print(">>>>>>>>>>>"+at.toString());
    setState(() {
      levelClock=at.difference(currentTime).inSeconds;
    });
    print(levelClock);
    return levelClock;
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    calcExpiryTime().whenComplete(() {
      setState(() {
        _controller = AnimationController(
          vsync: this,
          duration: Duration(
              seconds: levelClock), // gameData.levelClock is a user entered number elsewhere in the applciation
        );
      });
      _controller!.forward();
    });

  }

  void calltimer() {

  }


  @override
  Widget build(BuildContext context) {
    if(levelClock<=0)
    {
       return Container();
    }
    return Container(
      child: Container(
        child: Column(
          children: [
            Countdown(
              animation: StepTween(
                begin: levelClock, // THIS IS A USER ENTERED NUMBER
                end: 0,
              ).animate(_controller!),
            ),
          ],
        ),
      ),

    );
  }
}



class Countdown extends AnimatedWidget {
  Countdown( { Key? key,   required this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {

    Duration clockTimer1 = Duration(seconds: animation.value);


    String timerText =
        '${clockTimer1.inHours.remainder(60).toString().padLeft(2, '0')}:${clockTimer1.inMinutes.remainder(60).toString()..padLeft(2, '0')}:${clockTimer1.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    // print('animation.value  ${animation.value} ');
    // print('inHours ${clockTimer1.inHours.toString()}');
    // print('inMinutes ${clockTimer1.inMinutes.toString()}');
    // print('inSeconds ${clockTimer1.inSeconds.toString()}');
    // print('inSeconds.remainder ${clockTimer1.inSeconds.remainder(60).toString()}');
    // print('inMinutes.remainder ${clockTimer1.inMinutes.remainder(60).toString()}');
    // print('inHours.remainder ${clockTimer1.inHours.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 40,
        color: kSecondaryColor,
      ),
    );
  }
}

