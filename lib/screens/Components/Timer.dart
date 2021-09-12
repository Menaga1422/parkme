import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkme/theme.dart';


class Timer extends StatefulWidget {
  final int levelClock;
  const Timer({Key? key,required this.levelClock}) : super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> with SingleTickerProviderStateMixin
{

  AnimationController? _controller;



  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
          seconds:
          widget
              .levelClock), // gameData.levelClock is a user entered number elsewhere in the applciation
    );

    _controller!.forward();
  }

  void calltimer() {

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          children: [
            Countdown(
              animation: StepTween(
                begin: widget.levelClock, // THIS IS A USER ENTERED NUMBER
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