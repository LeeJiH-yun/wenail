import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert'; //JSON데이터 사용해서 가져옴
import 'package:http/http.dart' as http;

class myPage extends StatefulWidget {
  @override
  _myPageState createState() => _myPageState();
}

class _myPageState extends State<myPage> {
  List<Map> reserveArray = [
    {"date": "2022.07.24", "time": "13:30", "store" : "강남 우리네일", "state": "N"},
    {"date": "2022.07.26", "time": "12:30", "store" : "안산 우리네일", "state": "Y"}
  ];
  List<String> reserveArrayT = [
    "2022.07.24 13:30 - 강남 우리네일 (예약대기중)",
    "2022.07.26 12:30 - 안산 우리네일 (예약확정)"
  ];
  DateTime? currentBackPressTime;
  List data = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //메인화면에서 뒤로가기시 로그인화면으로 이동되는 것을 방지
      onWillPop: onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              appTitle(),
              Container(
                height: 100,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 30.0,
                          child: CircleAvatar(
                            backgroundImage: AssetImage('asset/images/user.png'),
                            backgroundColor: Color(0xffD5D5D5),
                            radius: 50.0,
                          )
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text("이지현", style: TextStyle(fontSize: 17.0, color: Color(0xff312B28))),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                child: Text("내정보수정하기", style: TextStyle(fontSize: 17.0, decoration: TextDecoration.underline, color: Color(0xff8C8C8C))),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
              Container(
                height: 30,
                color: Color(0xffEAEAEA)
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 5, right: 5),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Text("예약현황", style: TextStyle(color: Color(0xff312B28), fontSize: 20.0, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: /*data!.length == 0 ?
                  Container(
                      child: Text("예약내역이 없습니다.", style: TextStyle(fontSize: 20, color: Color(0xffD5D5D5)), textAlign: TextAlign.center)
                  ) :*/
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: reserveArray.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 40,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Color(0xffD5D5D5),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(reserveArrayT[index]),
                              ),
                              Container(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: (){
                                      alarmMsg("예약을 취소하겠습니까?", "RC");
                                    },
                                    child: Container(
                                      height: 35,
                                      padding: EdgeInsets.all(8),
                                      child: Text('취소하기', style: TextStyle(fontSize: 17.0, decoration: TextDecoration.underline, color: Color(0xff5D5D5D))),
                                    ),
                                  )
                                )
                              )
                            ],
                          ),
                        )
                      );
                    }
                  )
                )
            ]
          )
        )
      )
    );
  }

  Container appTitle() {//앱 타이틀
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 45,
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.brown.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              child: Text("우리네일", style: TextStyle(color: Color(0xffF7D6AD), fontSize: 17))
          ),
          SizedBox(width: 110),
          IconButton(
            color: Color(0xffF7D6AD),
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              alarmMsg("로그아웃 하겠습니까?", "LO");
            }
          )
        ]
      )
    );
  }

  void alarmMsg(text, type) { //예약취소 알림창: RC, 로그아웃 알림창: LO
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(text, textAlign: TextAlign.center),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          backgroundColor: Colors.white,
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text("취소"),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                  ),
                  TextButton(
                    child: Text("확인"),
                    onPressed: () {
                      if ("RC" == type) { //예약취소인 경우
                        Navigator.pop(context);
                      }
                      else { //로그아웃인 경우
                        Navigator.pop(context);
                      }
                    }
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      final _message = "뒤로 버튼을 한 번 더 누르면 종료됩니다.";
      final snackBar = SnackBar(content: Text(_message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    SystemNavigator.pop(); //앱 종료
    return true;
  }

  Future<String> getJSONData() async { //검색했을 때 데이터가 조회되도록
    var url = "내로컬주소로 해야하나 rest주소로 해야하나 ? target=store&query=userNo";
    var response = await http.get(Uri.parse(url));

    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      List result = dataConvertedToJSON["document"];
      data!.addAll(result);
    });
    return response.body;
  }
}