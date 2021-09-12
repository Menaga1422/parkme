import 'package:flutter/material.dart';
import 'package:parkme/screens/FindParking/bookedInfo.dart';
import 'package:parkme/screens/FindParking/booking.dart';
import 'package:parkme/screens/FindParking/parkingMap.dart';
import 'package:parkme/screens/FindParking/profile.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex=0;

  var tabs=[
    FindParking(),
    // Booking(),
    BookedInfo(),
    Profile(),
  ];

  void _onItemTapped(int index)
  {
    setState(() {
      _selectedIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_on),
                  label: "Park",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books_outlined),
                label: "Bookings",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: "Account",
              )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 5.0,
      ),
    );
  }
}
