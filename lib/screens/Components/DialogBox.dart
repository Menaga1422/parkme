import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final String? title;
  const DialogBox({Key? key,this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      // backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          height: 300,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10,5,10,10),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                    BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                    )]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Text(title!,
                      style: TextStyle(
                        fontFamily: 'Lobster',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,),
                    SizedBox(height: 10,),
                    Image(image: AssetImage("assets/success.png"),
                      height: 200,width: 120,),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}

