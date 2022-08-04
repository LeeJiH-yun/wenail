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
      appBar: AppBar(
        title: Text("우리네일"),
        centerTitle: true,
        automaticallyImplyLeading: false, //화살표 삭제
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () {Navigator.pop(context);}),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
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