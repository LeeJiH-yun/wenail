import 'package:flutter/material.dart';
import 'package:wenail/pages/reservePage.dart';
import 'package:flutter/services.dart';
import 'dart:convert'; //JSON데이터 사용해서 가져옴
import 'package:http/http.dart' as http;

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List <String>iconList = [
    'asset/images/test1.jpg',
    'asset/images/test2.jpg',
    'asset/images/test3.jpg',
    'asset/images/test4.jpg',
    'asset/images/test5.jpg',
    'asset/images/test6.jpg',
  ];
  DateTime? currentBackPressTime;
  List data = [];
  TextEditingController _editingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //메인화면에서 뒤로가기시 로그인화면으로 이동되는 것을 방지
      onWillPop: onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              Container(//앱 메인 이미지
                width: MediaQuery.of(context).size.width,
                height: 100,
                color: Colors.grey,
                child: Text("광고란"),
              ),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _editingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "네일샵 검색",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8)
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        getJSONData();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Icon(Icons.search, size: 45.0),
                      )
                    )
                  ],
                )
              ),
              SizedBox(height: 13.0),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: data!.length == 0 ?
                  Container(
                    child: Text("조회된 목록이 없습니다.", style: TextStyle(fontSize: 20, color: Color(0xffD5D5D5)), textAlign: TextAlign.center)
                  ) :
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), //이거 넣으니까 일단 스크롤은 됨..찾아봐야한다.
                    itemCount: iconList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 100,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(iconList[index]),
                            fit: BoxFit.fill
                          )
                        ),
                        child: Container(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child:
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => reservePage()));
                              },
                              child: Container(
                                  height: 30,
                                  width: 100,
                                  padding: EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text('예약하러가기', style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
                              ),
                            )
                          )
                        )
                      );
                    },
                  )

              )
            ]
          )
        ),
      )
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
    var url = "내로컬주소로 해야하나 rest주소로 해야하나 ? target=store&query=${_editingController}";
    var response = await http.get(Uri.parse(url));

    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      List result = dataConvertedToJSON["document"];
      data!.addAll(result);
    });
    return response.body;
  }
}