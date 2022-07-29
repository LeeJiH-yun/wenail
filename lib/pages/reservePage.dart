import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class reservePage extends StatefulWidget {
  const reservePage({Key? key}) : super(key: key);

  @override
  _reserveState createState() => _reserveState();
}

class _reserveState extends State<reservePage> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();
  List<Map> timeArray = [{"time": "12:00"}, {"time": "12:30"}, {"time": "13:00"}, {"time": "13:30"}, {"time": "14:00"}, {"time": "14:30"},
  {"time": "15:00"}, {"time": "15:30"}];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar (
          title: Text("우리네일"),
          centerTitle: true,
          elevation: 0, //그림자 없애주기
        ),
        body: SingleChildScrollView( //overflow 오류가 나서 추가함
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                TableCalendar(
                  focusedDay: focusedDay, //달력에서 자동으로 보여줄 날
                  firstDay: DateTime.now(), //오늘 이전 날짜는 선택이 안되게 막는다.
                  lastDay: DateTime.now().add(Duration(days: 365*10 + 2)),
                  locale: 'ko-KR',
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                    setState(() {
                      //선택된 날짜의 상태를 갱신한다.
                      print(selectedDay);
                      this.selectedDay = selectedDay;
                      this.focusedDay = focusedDay;
                    });
                  },
                  selectedDayPredicate: (DateTime day) {
                    //selectedDay 와 동일한 날짜의 모양을 바꿔준다.
                    return isSameDay(selectedDay, day);
                  },
                  onPageChanged: (focusedDay) {
                    this.focusedDay = focusedDay;
                  },
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        child:Text('시간선택',style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Icon(Icons.refresh),
                      )
                    ],
                  )
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                Stack(
                  children: [
                    Container(
                      height: 150,
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: timeArray.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                      child: InkWell(
                                          onTap: (){},
                                          child: Align( //글자가 왼쪽으로 정렬이 안되서 추가함
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                                color: Colors.white,
                                                padding: EdgeInsets.only(top: 5),
                                                margin: EdgeInsets.only(left: 8),
                                                child: Text(timeArray[index]["time"], style: TextStyle(fontSize: 15.0))
                                            ),
                                          )
                                      )
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      )
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        color: Color(0xffD5D5D5),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10, right: 5),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => reservePage()));
                              },
                              child: Container(
                                  height: 30,
                                  width: 100,
                                  padding: EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text('예약하기', style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
                              ),
                            )
                          )
                        )
                      ),
                    ),
                  ],
                )
                // Container(
                //   child: Column(
                //     children: [
                //       ListView.builder(
                //         shrinkWrap: true,
                //         physics: NeverScrollableScrollPhysics(),
                //         itemCount: timeArray.length,
                //         itemBuilder: (BuildContext context, int index) {
                //           return Column(
                //             children: [
                //               Container(
                //                   child: InkWell(
                //                   onTap: (){},
                //                   child: Align( //글자가 왼쪽으로 정렬이 안되서 추가함
                //                     alignment: Alignment.centerLeft,
                //                     child: Container(
                //                       color: Colors.white,
                //                       padding: EdgeInsets.only(top: 5),
                //                       margin: EdgeInsets.only(left: 8),
                //                       child: Text(timeArray[index]["time"], style: TextStyle(fontSize: 15.0))
                //                     ),
                //                   )
                //                 )
                //               ),
                //               Divider(
                //                 thickness: 1,
                //                 color: Colors.grey,
                //               ),
                //             ],
                //           );
                //         },
                //       ),
                //     ],
                //   )
                // )
            ],
          )
        )
    );
  }
}
