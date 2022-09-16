import 'dart:convert'; //JSON데이터 사용해서 가져옴
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wenail/service/apiUrl.dart';

class reservePage extends StatefulWidget {
  final String data; //Map형식으로 넘겨줘서 이렇게 선언함
  const reservePage(this.data); //넘어온 데이터 사용

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

  bool _isLoading = false; //로딩 여부
  bool _isTimeLoading = false; //시간목록 새로고침 할 때
  bool _isFail = false; //서버 연결 여부 상품설명에서 사용하려고
  bool _visibility = false, //예약하기 하단바 보여주기 여부
      _goodsVisibility = false, //상품목록 보여주기 여부
      _timeVisibility = false; //시간 보여주기 여부

  List<dynamic> goodsGetList = [];
  List<dynamic> timesGetList = [];
  List<dynamic> goodsImage = [];

  int timeSelected = 0, goodsSelected = 0;
  late int weekdayNum;

  // @override
  void initState() {
    super.initState();
    //데이터 응답받기 전에 로딩 추가하기
    getGoodsListData(); //상품목록 api 호출
    _goodsVisibility = true; //맨처음 들어왔을 때 맨처음 것이 디폴트로 보이게 할거라.. 일단 넣어봄ㅅ
    _timeVisibility = true;
  }

  void printMSG(status) {
    setState(() {
      if (200 == status) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("예약이 신청되었습니다.", style: TextStyle(color: Color(0xff312B28)), textAlign: TextAlign.center),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.white,
              actions: [
                Center(
                    child: TextButton(
                      child: Text("확인", style: TextStyle(color: Color(0xff312B28))),
                      onPressed: () {
                        Navigator.of(context).pop(); Navigator.of(context).pop();
                      },
                    )
                )
              ],
            );
          },
        );
      }
      else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("서버가 불안정합니다.\n다시 시도해주세요.", style: TextStyle(color: Color(0xff312B28)), textAlign: TextAlign.center),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.white,
              actions: [
                Center(
                    child: TextButton(
                      child: Text("확인", style: TextStyle(color: Color(0xff312B28))),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                )
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("우리네일", style: TextStyle(color: Color(0xffF7D6AD))),
          centerTitle: true,
          elevation: 0, //그림자 없애주기
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () =>
              { //달력 새로고침을 위해 넣었는데 수정해야 할 것 같다.
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => super.widget))
              },
            ),
          ]
      ),
      body: SingleChildScrollView( //overflow 오류가 나서 추가함
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TableCalendar(
                focusedDay: focusedDay,
                //달력에서 자동으로 보여줄 날
                firstDay: DateTime.now(),
                //오늘 이전 날짜는 선택이 안되게 막는다.
                lastDay: DateTime.now().add(Duration(days: 365 * 10 + 2)),
                locale: 'ko-KR',
                calendarBuilders: CalendarBuilders( //일요일에 빨간 표시
                  dowBuilder: (context, day) {
                    weekdayNum = day.weekday; //넘길 파라미터 저장
                    if (day.weekday == DateTime.sunday) {
                      return Center(
                          child: Text("일", style: TextStyle(color: Colors.red))
                      );
                    }
                  },
                  selectedBuilder: (context, date, events) => Container( // 선택된 날짜 꾸미기
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffF7D6AD),
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        //fontFamily: 'Montserrat',
                        //fontWeight: FontWeight.w600,
                        //fontSize: 12,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  todayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xfffae8d1),
                      borderRadius: BorderRadius.circular(60.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Color(0xff000000)),
                    )
                  ),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false //현재 월의 달력만 보여준다.
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  setState(() {
                    print("넘어온 데이터 확인" + widget.data);
                    //선택된 날짜의 상태를 갱신한다.
                    this.selectedDay = selectedDay;
                    if (selectedDay != this.focusedDay || (selectedDay == this.focusedDay) && _timeVisibility || (selectedDay == this.focusedDay) && _goodsVisibility) {
                      //선택했던 날짜랑 다르거나 이전에 선택했던 날짜를 다시 선택했을 경우 (시간선택은 열려있고)
                      setState(() {
                        _visibility = false;
                        _isLoading = false;
                        goodsSelected = 0;
                        getGoodsListData();
                      });
                    }
                    // if (selectedDay != this.focusedDay || (selectedDay == this.focusedDay) && _goodsVisibility) {setState(() { //선택했던 날짜랑 다르거나 이전에 선택했던 날짜를 다시 선택했을 경우 (상품선택은 열려있고)
                    //     _timeVisibility = false;
                    //   });
                    // }
                  });
                },
                selectedDayPredicate: (DateTime day) {
                  return isSameDay(selectedDay, day);
                },
                onPageChanged: (focusedDay) {
                  setState(() { //달력 월을 넘길 때
                    _isLoading = false;
                    _visibility = false;
                    getGoodsListData(); //상품목록 새로고침..
                  });
                  this.focusedDay = focusedDay;
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              goodsTitle(), //상품선택 타이틀
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Visibility( //상품 목록
                visible: _goodsVisibility,
                child: !_isLoading ? CircularProgressIndicator(color: Color(0xffF7D6AD), strokeWidth: 3.0) : goodsList()
              ),
              Visibility( //상품 설명
                visible: _goodsVisibility,
                child: _isLoading ? prodDetail() : Container(height: 20,child: Text("조회된 상품이 없습니다.", style: TextStyle(color: Color(0xffF7D6AD))))
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              timesTitle(), //시간선택 타이틀
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Visibility( //시간 목록
                visible: _timeVisibility,
                child: !_isLoading && !_isFail ?
                Container(
                    child: Text("조회된 상품 목록이 없습니다.", style: TextStyle(fontSize: 15, color: Color(0xff312B28)), textAlign: TextAlign.center)
                ) :
                (!_isTimeLoading) ? CircularProgressIndicator(color: Colors.blue, strokeWidth: 3.0) : timesList()
              )
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
                      onTap: () {
                        //Navigator.push();
                        reserveConfirm();
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => reserveConfirmPage()));
                        //setReserveData();
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        padding: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('예약하기', style: TextStyle(color: Color(0xffF7D6AD)), textAlign: TextAlign.center)
                      ),
                    )
                )
            )
        )
      ),
    );
  }

  Container goodsTitle() {//상품 선택
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(left: 5),
      child: Container(
        child: Row(
          children: [
            Text('상품선택', style: TextStyle(color: Color(0xff312B28), fontSize: 15.0, fontWeight: FontWeight.bold)),
            InkWell(
              onTap: () {
                _isLoading = false;
                getGoodsListData();
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(Icons.refresh),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container goodsList() {//상품 목록
    return Container(
        margin: EdgeInsets.all(10),
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: goodsGetList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  //상품선택시 시간 목록을 보여준다.
                  _timeVisibility = true;
                  _isTimeLoading = false;
                  getTimesListData(); //시간 목록 구하기

                  goodsSelected = index;
                  if (_visibility) { //시간이 선택되어있다면 다른 상품 선택시 초기화 시키도록 함
                    _visibility = false;
                  }
                });
              },
              child: Container(
                  width: 100,
                  margin: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    //_timeVisibility &&
                    color: (goodsSelected == index) ? Color(0xffF7D6AD) : Color(0xffb47764),
                    border: Border.all(color: Colors.black),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: const Offset(0,7),
                      )
                    ]
                  ),
                  child: goodsGetList.length == 0 ?
                  Container(
                      child: Text("조회된 상품 목록이 없습니다.", style: TextStyle(fontSize: 20, color: Color(0xffD5D5D5)), textAlign: TextAlign.center)
                  ) :
                  Column(
                    children: [
                      Text(goodsGetList![index]["productTitle"],style: TextStyle(fontSize: 20.0, height: 1.6), textAlign: TextAlign.center),
                      Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      Text(goodsGetList![index]["productPrice"].toString() + "원", style: TextStyle(fontSize: 17.0, height: 1.6), textAlign: TextAlign.center)
                    ]
                  )
              )
            );
          }
        )
    );
  }

  Row prodDetail() {//상품 설명
    return _isFail ? Row(children: [Container(child: Text("상품이 없습니다.", style: TextStyle(fontSize: 17.0, color: Color(0xff777777)), textAlign: TextAlign.center))]) :
    //조회 실패했을 경우 _isFail
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 200,
          height: 200,
          margin: EdgeInsets.only(left: 3),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: Image.memory(goodsImage[goodsSelected]).image/*as ImageProvider*/,
              fit: BoxFit.fill
            )
          ),
        ),
        Container(
          width: 200,
          height: 200,
          margin: EdgeInsets.only(right: 3),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(0xff666666)
            )
          ),
          child: SingleChildScrollView( //스크롤 넣기
            child: Text(_goodsVisibility && _timeVisibility ? goodsGetList![goodsSelected]["productContent"] : "상품을 선택해주세요.", style: TextStyle(fontSize: 17.0, height: 1.6), textAlign: TextAlign.left),
          )
        )
      ],
    );
  }

  Container timesTitle() {//시간선택 타이틀
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Container(
            child: Text('시간선택', style: TextStyle(color: Color(0xff312B28), fontSize: 15.0, fontWeight: FontWeight.bold)),
          ),
          InkWell(
            onTap: () {
              _isTimeLoading = false;
              getTimesListData();
            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Icon(Icons.refresh)
            ),
          )

        ],
      )
    );
  }

  Container timesList() {//시간 목록
    return Container(
      margin: EdgeInsets.all(10),
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: timesGetList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                if (0 == timesGetList![index]["dayReserve"]) {
                  //예약 가능한 수가 0이면 예약 불가 알림창을 띄워준다.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("예약이 불가능한 시간입니다.\n다른 시간을 선택해주세요.", textAlign: TextAlign.center),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: Colors.white,
                        actions: [
                          TextButton(
                            child: Center(
                              child: Text("확인"),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                  );
                }
                else {
                  //시간 선택시 예약하기 버튼을 보여준다.
                  _visibility = true;
                  timeSelected = index;
                }
              });
            },
            child: timesGetList.length == 0 ?
            Container(
                child: Text("예약 가능한 시간이 없습니다.", style: TextStyle(fontSize: 20, color: Color(0xffD5D5D5)), textAlign: TextAlign.center)
            ) :
            Container(
              width: 100,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: (_visibility && timeSelected == index) ? Color(0xffF7D6AD) : ((0 == timesGetList![index]["dayReserve"]) ? Color(0xffD5D5D5) : Color(0xffb47764)),
                //예약 가능한 수가 0이면 예약 못한다는 표시로 색을 변경한다.
                border: Border.all(color: Colors.black),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                    offset: const Offset(0,7),
                  )
                ]
              ),
              child: Column(
                children: [
                  Text(timesGetList[index]["dayTime"].toString() + ":", style: TextStyle(fontSize: 20.0, height: 1.6), textAlign: TextAlign.center),
                ]
              )
            )
          );
        }
      )
    );
  }

  void reserveConfirm() { //예약 확인 안내창
    setState(() {
      showDialog(
        context: context,
        barrierDismissible: false, //Dialog를 제외한 다른 화면 터치 x
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("테스트")
              ],
            ),
            actions: [
              TextButton(
                child: Text("예약신청"),
                onPressed: () {
                  setReserveData();
                },
              ),
            ],
          );
        });
    });
  }
  
  void getGoodsListData() async { //상품 목록 조회
    var url = Url().commonUrl + "/api/product/list?storeCode=${widget.data}";

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8'
      }
    );

    if (response.statusCode == 200) {
      setState(() {
        goodsGetList = []; //초기화 해줘야 이미 들어있는 값에 추가해서 나오지 않는다..
        String responseBody = utf8.decode(response.bodyBytes);
        List<dynamic> goodsList = jsonDecode(responseBody).toList();
        goodsGetList!.addAll(goodsList);

        for (int i=0; goodsList.length > i; i++) {
          String baseTest = goodsList[i]["productImage"];
          Uint8List myImage = Uri.parse(baseTest).data!.contentAsBytes();
          goodsImage.add(myImage);
        }

        Future.delayed(Duration(milliseconds: 900), () {
          setState(() {
            _isLoading = true;
            getTimesListData(); //시간 목록 조회
          });
        });
        print("goodsGetList?: ${goodsGetList}");
        print("responseBody?: ${response.body}");
      });
    }
    else {
      setState(() {
        _isLoading = true;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("데이터 조회에 실패했습니다.\n다시 시도해주세요.", textAlign: TextAlign.center),
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
                        Navigator.of(context).pop();;
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        }
      );
      throw "서버 연결이 끊겼습니다.\n다시 시도해주세요.";
    }
  }

  void getTimesListData() async { //시간 목록 조회
    var url = Url().commonUrl + "/api/reserve/day/${weekdayNum}?storeCode=${widget.data}";
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8'
      }
    );

    if (response.statusCode == 200) {
      setState(() {
        timesGetList = []; //초기화 해줘야 이미 들어있는 값에 추가해서 나오지 않는다..
        String responseBody = utf8.decode(response.bodyBytes);
        List<dynamic> timesList = jsonDecode(responseBody).toList();
        timesGetList!.addAll(timesList);
        Future.delayed(Duration(milliseconds: 900), () {
          setState(() {
            _isTimeLoading = true;
          });
        });
        print("weekdayNum?: ${weekdayNum}");
        print("timesList?: ${timesList}");
      });
    }
    else {
      setState(() {
        _isTimeLoading = true;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("데이터 조회에 실패했습니다.\n다시 시도해주세요.", textAlign: TextAlign.center),
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
                          Navigator.of(context).pop();;
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          }
      );
      throw "서버 연결이 끊겼습니다.\n다시 시도해주세요.";
    }
  }

  Future<String> setReserveData() async { //예약하기
    var url = Url().commonUrl + "/api/reserve/";
    final DateTime now = selectedDay; //selectedDay는 시간까지 출력해서 값을 변경시키기 위함
    final DateFormat formatter = DateFormat('yyyyMMdd');
    final String formatted = formatter.format(now);

    Map<String, String> data = {
      "productCode": goodsGetList[goodsSelected]["productCode"].toString(),
      "reserveDate": formatted.toString(),
      "reserveTime": timesGetList[timeSelected]["dayTime"].toString(),
      "storeCode": widget.data.toString(),
      "userId": "test", //로그인한 아이디를 넣어주도록 처리한다.
    };
    var bodys = json.encode(data);

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String> {
        'Content-type' : 'application/json; charset=UTF-8'
      },
      body: bodys
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes); //한글깨질때
      print(responseBody);
    }
    else {
      print("failed to save data");
    }

    printMSG(response.statusCode);
    return response.body;
  }
}
