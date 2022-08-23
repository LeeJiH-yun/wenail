import 'package:flutter/material.dart';
import 'package:wenail/pages/homePage.dart';
import 'package:wenail/pages/myPage.dart';

class homeMain extends StatefulWidget {
  final String data; //Map형식으로 넘겨줘서 이렇게 선언함
  const homeMain(this.data); //넘어온 데이터 사용

  @override
  _homeMainState createState() => _homeMainState();
}

class _homeMainState extends State<homeMain> {
  int _selectedIndex = 0;
  static List<Widget> pages = [homePage(),myPage()];

  void _onItemTapped(int index) {
    setState(() {
      print("this.data??"+ widget.data); //로그인시 넘어온 데이터 이걸 mypage에서 뿌려줘야한다..
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