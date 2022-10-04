import 'dart:convert'; //JSON데이터 사용해서 가져옴

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wenail/pages/reservePage.dart';
import 'package:wenail/service/apiUrl.dart';

class homePage extends StatefulWidget {
  //final String data; //Map형식으로 넘겨줘서 이렇게 선언함
  //const homePage(this.data); //넘어온 데이터 사용

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  DateTime? currentBackPressTime;

  List<dynamic> storeListData = [];
  List<Map> data = [
    {"STORE" : "안산 뷰티네일샵", "STORE_CODE" : "WN0002", "image": "asset/images/test1.jpg"},
    {"STORE" : "안산 뷰티네일샵test", "STORE_CODE" : "WN000133", "image": "asset/images/test2.jpg"}
  ];
  TextEditingController _editingController = TextEditingController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  bool _isLoading = false; //로딩 여부

  // @override
  void initState() {
    super.initState();
    getListData(); //가게 목록 api 호출
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    print("새로고침..");
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // 상태바 숨기기
    return WillPopScope( //메인화면에서 뒤로가기시 로그인화면으로 이동되는 것을 방지
      onWillPop: onWillPop,
      child: Scaffold(
        body: SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: Column(
            children: <Widget>[
              appTitle(),
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
                        width: 310,
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
                            setState(() {
                              _isLoading = false;
                              getListData();
                            });
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
              !_isLoading ? CircularProgressIndicator(color: Color(0xffF7D6AD), strokeWidth: 3.0) : storeList(),
            ]
          )
        )

        // body: SingleChildScrollView(
        //   scrollDirection: Axis.vertical,
        //   child: Column(
        //     children: <Widget>[
        //       appTitle(),
        //       Container(//앱 메인 이미지
        //         width: MediaQuery.of(context).size.width,
        //         height: 100,
        //         color: Colors.grey,
        //         child: Text("광고란"),
        //       ),
        //       SizedBox(height: 15.0),
        //       Container(
        //         padding: EdgeInsets.only(left: 20, right: 20),
        //         child: Row(
        //           children: [
        //             SizedBox(
        //               width: 310,
        //               child: TextField(
        //                 controller: _editingController,
        //                 keyboardType: TextInputType.text,
        //                 decoration: InputDecoration(
        //                   hintText: "네일샵 검색",
        //                   border: OutlineInputBorder(),
        //                   contentPadding: EdgeInsets.all(8)
        //                 ),
        //               ),
        //             ),
        //             InkWell(
        //               onTap: () async {
        //                 setState(() {
        //                   _isLoading = false;
        //                   getListData();
        //                 });
        //               },
        //               child: Container(
        //                 margin: EdgeInsets.only(left: 15),
        //                 child: Icon(Icons.search, size: 45.0),
        //               )
        //             )
        //           ],
        //         )
        //       ),
        //       SizedBox(height: 13.0),
        //       Divider(
        //         thickness: 1,
        //         color: Colors.grey,
        //       ),
        //       !_isLoading ? CircularProgressIndicator(color: Color(0xffF7D6AD), strokeWidth: 3.0) : storeList(),
        //     ]
        //   )
        ),
      );
    //);
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text("로그아웃 하겠습니까?", textAlign: TextAlign.center),
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
                                },
                              ),
                              TextButton(
                                child: Text("확인"),
                                onPressed: () {
                                  //테이블에 저장된 토큰값을 지워줘야할듯싶음
                                  Navigator.of(context).pop(); Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                );
              }
            )
          ]
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

  Container storeList() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: storeListData!.length == 0 ?
      Container(
          child: Text("조회된 목록이 없습니다.", style: TextStyle(fontSize: 20, color: Color(0xffD5D5D5)), textAlign: TextAlign.center)
      ) :
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(), //이거 넣으니까 일단 스크롤은 됨..찾아봐야한다.
        itemCount: storeListData.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                height: 100,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(data[index]["image"]),
                    fit: BoxFit.fill
                  )
                ),
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child:
                      InkWell(
                        onTap: () {
                            print(storeListData[index]);
                          //선택한 데이터 넘기기
                            Navigator.push(context,MaterialPageRoute(builder: (context) => reservePage(storeListData[index]["storeCode"]))
                          );
                        },
                        child: Container(
                          height: 30,
                          width: 100,
                          padding: EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFF06E4235),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(storeListData[index]["storeName"], style: TextStyle(color: Color(0xffF7D6AD)), textAlign: TextAlign.center)
                        ),
                      )
                  )
                )
              )
            ],
          );
        },
      )
    );
  }

  void getListData() async { //검색했을 때 데이터가 조회되도록
    var url = Url().commonUrl + "/api/store/list?store=${_editingController.text}";

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8'
      }
    );

    if (response.statusCode == 200) {
      setState(() {
        storeListData = []; //초기화
        String responseBody = utf8.decode(response.bodyBytes);
        List<dynamic> timesList = jsonDecode(responseBody).toList();
        storeListData!.addAll(timesList);
        Future.delayed(Duration(milliseconds: 900), () {
          setState(() {
            _isLoading = true;
          });
        });
        print("storeListData?: ${storeListData}");
      });
    }
    else {
      setState(() {
        _isLoading = true;
      });
      throw "서버 연결이 끊겼습니다.\n다시 시도해주세요.";
    }
  }
}