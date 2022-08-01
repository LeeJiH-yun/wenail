import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
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
                              child: Text("이지현", style: TextStyle(fontSize: 17.0)),
                            ),
                            SizedBox(height: 13.0),
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
            //SizedBox(height: 13.0),
            Container(
              height: 30,
              color: Color(0xffEAEAEA)
            ),
            // Divider(
            //   thickness: 1,
            //   color: Colors.grey,
            // ),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(left: 5, right: 5),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Text("예약현황", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ListView.builder(
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
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text("예약을 취소하겠습니까?", textAlign: TextAlign.center),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                        backgroundColor: Colors.white,
                                        actions: [
                                          FlatButton(
                                            child: Text("취소"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("확인"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Container(
            //       padding: EdgeInsets.all(5),
            //       margin: EdgeInsets.only(left: 5),
            //       width: MediaQuery.of(context).size.width,
            //       height: 50,
            //       color: Colors.blue,
            //       child: Text("예약현황", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            //     ),
            //     ListView.builder(
            //       itemCount: reserveArray.length,
            //       itemBuilder: (context, index) {
            //         return Container(
            //             child: Text("테스트")
            //         );
            //       }
            //     )
            //     Container(
            //       height: 30,
            //       margin: EdgeInsets.all(10),
            //       child: ListView.builder(
            //         itemCount: reserveArray.length,
            //         itemBuilder: (context, index) {
            //           return Container(
            //             width: 100,
            //             margin: EdgeInsets.all(6),
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(15),
            //               //color: (_visibility && selected == index) ? Colors.transparent : Colors.blue,
            //               border: Border.all(color: Colors.black),
            //             ),
            //             child: Text(reserveArray[index]["store"], style: TextStyle(fontSize: 20.0, height: 1.6), textAlign: TextAlign.center)
            //           );
            //         }
            //       ),
            //     )
            //   ],
            // )
          ]
        )
      )
    );
  }
}