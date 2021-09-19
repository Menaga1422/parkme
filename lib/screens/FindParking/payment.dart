import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkme/utils/ParkingModel.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Pay extends StatefulWidget {
  final ParkingModel parklot;
  final String duration;
  const Pay({Key? key,required this.parklot,required this.duration}) : super(key: key);

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  late Razorpay razorpay;
  TextEditingController textEditingController=new TextEditingController();
  @override
  void initState(){
    super.initState();
    razorpay=new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);

  }
  @override
  void dispose(){
    super.dispose();
    razorpay.clear();
  }
  void openCheckout(){
    var options={
      "key":"rzp_test_3vevAqMJ8LY2zQ",
      "amount":num.parse((widget.parklot.price * 3).toString())*100,
      "prefill":{
        "contact":"",
        "email":"",
      },
      "external":{
        "wallet":["paytm"]
      }
    };
    try{
      razorpay.open(options);
    }
    catch(e){
      print(e.toString());
    }
  }
  void handlerPaymentSuccess(){
    print("payment success");
    // Toast.show("Payment succcess",context);
  }
  void handlerErrorFailure(){
    print("payment fails");

  }
  void handlerExternalWallet(){
    print("External Wallet");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Page"),
      ),
      body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
    padding: EdgeInsets.only(left: 10,right: 10),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(
    child: Text("${widget.parklot.parkName} Parking",
    style: GoogleFonts.lato(
    fontWeight: FontWeight.w800,
    fontSize: 25,
    color: Colors.black87
    ),
    )),
    Text("${widget.parklot.parkingType}",
      style: GoogleFonts.lato(
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: Colors.black54
      ),
    ),
    SizedBox(height: 20,),
    Text("${widget.parklot.price.toString()} X ${widget.duration} = \u{20B9} ${(widget.parklot.price * 3).toString()}",
    style: GoogleFonts.lato(
    fontWeight: FontWeight.w800,
    fontSize: 20,
    color: Colors.black87
    ),
    ),
      Divider(color: Colors.black54,),
          SizedBox(height: 12,),
          Center(
            child: ElevatedButton(
              child: Text("Pay Now"),
              onPressed: () {
                  openCheckout();
              },
            ),
          ),
        ],
      ),
      ),
    ));
  }
}
