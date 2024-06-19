import 'package:bubblecloud/pages/main/HomeScreen.dart';
import 'package:bubblecloud/pages/main/LikedScreen.dart';
import 'package:flutter/material.dart';
import './PostWindow.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;
  const BottomNavigation({Key? key, required this.selectedIndex});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  // int _selectedIndex = widget.selectedIndex;

  void _onItemTapped(int index) {
    if (index == 1) {
      // Show the bottom sheet
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: PostWindow(),
          );
        },
      );
    } else if (index == 2) {
      if (index != widget.selectedIndex) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LikedScreen()));
      }
    } else {
      if (index != widget.selectedIndex) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: _onItemTapped,
      iconSize: 32,

      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.black),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Post',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Liked",
            backgroundColor: Colors.black)
      ],
      selectedItemColor: Color(0xff9FBDF9),
      unselectedItemColor: Colors.black54,
      // showSelectedLabels: false,
      // showUnselectedLabels: false,
    );
  }
}
