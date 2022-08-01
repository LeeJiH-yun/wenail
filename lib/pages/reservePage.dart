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

  bool _visibility = false, //예약하기 하단바 보여주기 여부
       _timeVisibility = false; //시간 보여주기 여부

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar (
          title: Text("우리네일"),
          centerTitle: true,
          elevation: 0, //그림자 없애주기
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.calendar_today),
              onPressed: () => { //달력 새로고침을 위해 넣었는데 수정해야 할 것 같다.
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context) => super.widget))
              },
            ),
          ]
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
                availableCalendarFormats: const {
                  CalendarFormat.month: '오늘',
                  CalendarFormat.twoWeeks: '오늘',
                },
                calendarStyle: CalendarStyle(
                    outsideDaysVisible: false //현재 월의 달력만 보여준다.
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  setState(() {
                    //선택된 날짜의 상태를 갱신한다.
                    _timeVisibility = true;

                    this.selectedDay = selectedDay;
                    //this.focusedDay = focusedDay;
                    if (selectedDay != this.focusedDay || (selectedDay == this.focusedDay) && _timeVisibility) {
                      //선택했던 날짜랑 다르거나 이전에 선택했던 날짜를 다시 선택했을 경우
                      setState(() {
                        _visibility = false;
                      });
                    }
                  });
                },
                selectedDayPredicate: (DateTime day) {
                  return isSameDay(selectedDay, day);
                },
                onPageChanged: (focusedDay) {
                  setState(() { //달력 월을 넘길 때
                    _timeVisibility = false;
                    _visibility = false;
                  });
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
                margin: EdgeInsets.only(left: 5),
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
              Visibility(
                visible: _timeVisibility,
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: timeArray.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            //시간 선택시 예약하기 버튼을 보여준다.
                            _visibility = true;
                            selected = index;
                          });
                        },
                        child: Container(
                            width: 100,
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: (_visibility && selected == index) ? Colors.transparent : Colors.blue,
                              border: Border.all(color: Colors.black),
                            ),
                            child: Text(timeArray[index]["time"], style: TextStyle(fontSize: 20.0, height: 1.6), textAlign: TextAlign.center)
                        )
                      );
                    }
                  )
                ),
              ),
            ],
          )
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xffD5D5D5),
          child: Visibility(
            visible: _visibility,
            child: Align(
              heightFactor: 1.2,
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(bottom: 10, right: 5),
                child: InkWell(
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("예약신청이 됐습니다.", textAlign: TextAlign.center),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: Colors.white,
                          actions: [
                            Center(
                              child: FlatButton(
                                child: Text("확인"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    padding: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('예약하기', style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
                  ),
                )
              )
            )
          )
        ),
    );
  }
}
