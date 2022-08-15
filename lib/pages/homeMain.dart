import 'package:flutter/material.dart';
import 'package:wenail/pages/homePage.dart';
import 'package:wenail/pages/myPage.dart';

class homeMain extends StatefulWidget {
  @override
  _homeMainState createState() => _homeMainState();
}

class _homeMainState extends State<homeMain> {
  int _selectedIndex = 0;
  static List<Widget> pages = [homePage(),myPage()]; //탭 선택시 이동할 화면 class

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        fixedColor: Colors.brown,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
            label: "MyPage",
            icon: Icon(Icons.person)
          ),
        ],
      ),
    );
  }
}