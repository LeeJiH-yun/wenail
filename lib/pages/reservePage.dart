import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert'; //JSON데이터 사용해서 가져옴
import 'package:http/http.dart' as http;

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
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  List<Map> timeArray = [{"time": "12:00"}, {"time": "12:30"}, {"time": "13:00"}, {"time": "13:30"}, {"time": "14:00"}, {"time": "14:30"},
  {"time": "15:00"}, {"time": "15:30"}];

  List<Map> goodsArray = [
    {"goods_image": "", "goods_name": "손케어", "price": "20,000", "content": "손 정리"},
    {"goods_image": "", "goods_name": "발케어", "price": "30,000", "content": "발 정리"},
    {"goods_image": "", "goods_name": "젤네일", "price": "50,000", "content": "젤 네일입니다"},
    {"goods_image": "", "goods_name": "젤패디", "price": "60,000", "content": "젤 패디입니다"}
  ];
  List<dynamic> goodsGetList = [];

  bool _visibility = false, //예약하기 하단바 보여주기 여부
       _goodsVisibility = false, //상품목록 보여주기 여부
       _timeVisibility = false; //시간 보여주기 여부

  int timeSelected = 0,
      goodsSelected = 0;

  // @override
  void initState() {
    super.initState();
    //데이터 응답받기 전에 로딩 추가하기
    getGoodsListData(); //상품목록 api 호출
    _goodsVisibility = true; //맨처음 들어왔을 때 맨처음 것이 디폴트로 보이게 할거라.. 일단 넣어봄ㅅ
    _timeVisibility = true;
    _visibility = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar (
          title: Text("우리네일", style: TextStyle(color: Color(0xffF7D6AD))),
          centerTitle: true,
          elevation: 0, //그림자 없애주기
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.calendar_today),
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
                calendarBuilders: CalendarBuilders( //일요일에 빨간 표시
                  dowBuilder: (context, day) {
                    if (day.weekday == DateTime.sunday) {
                      return Center(
                        child: Text("일",style: TextStyle(color: Colors.red))
                      );
                    }
                  }
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
                    //getGoodsListData(); //상품목록 api 호출
                    //_goodsVisibility = true;
                    this.selectedDay = selectedDay;
                    if (selectedDay != this.focusedDay || (selectedDay == this.focusedDay) && _timeVisibility || (selectedDay == this.focusedDay) && _goodsVisibility) {
                      //선택했던 날짜랑 다르거나 이전에 선택했던 날짜를 다시 선택했을 경우 (시간선택은 열려있고)
                      setState(() {
                        _visibility = false;
                      });
                    }
                    if (selectedDay != this.focusedDay || (selectedDay == this.focusedDay) && _goodsVisibility) {
                      setState(() {//선택했던 날짜랑 다르거나 이전에 선택했던 날짜를 다시 선택했을 경우 (상품선택은 열려있고)
                        //_timeVisibility = false;
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
                    _goodsVisibility = false;
                    _visibility = false;
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
              Visibility(  //상품 목록
                visible: _goodsVisibility,
                child: !_isLoading ? CircularProgressIndicator(color: Color(0xffF7D6AD), strokeWidth: 3.0) : goodsList()
              ),
              Visibility(  //상품 설명
                  visible: _goodsVisibility,
                  child: _isLoading ? prodDetail() : Container(height: 20, child: Text("조회된 상품이 없습니다.", style: TextStyle(color: Color(0xffF7D6AD))))
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
              Visibility(  //시간 목록
                visible: _timeVisibility,
                child: timesList()
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
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("예약신청이 됐습니다.", style: TextStyle(color: Color(0xff312B28)), textAlign: TextAlign.center),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: Colors.white,
                          actions: [
                            Center(
                              child: TextButton(
                                child: Text("확인", style: TextStyle(color: Color(0xff312B28))),
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

  Container goodsTitle() { //상품 선택
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(left: 5),
      child: Container(
          child: Row(
          children: [
            Text('상품선택',style: TextStyle(color: Color(0xff312B28), fontSize: 15.0, fontWeight: FontWeight.bold)),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }

  Container goodsList() { //상품 목록
    return Container(
      margin: EdgeInsets.all(10),
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: goodsGetList == null ? 0 : goodsGetList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                //상품선택시 시간 목록을 보여준다.
                _timeVisibility = true;
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
                borderRadius: BorderRadius.circular(15), //_timeVisibility &&
                color: (goodsSelected == index) ? Colors.transparent : Colors.blue,
                border: Border.all(color: Colors.black),
              ),
              child: goodsGetList.length == 0 ?
              Container(
                  child: Text("조회된 상품 목록이 없습니다.", style: TextStyle(fontSize: 20, color: Color(0xffD5D5D5)), textAlign: TextAlign.center)
              ) :
              Column(
                  children: [
                    Text(goodsGetList![index]["productTitle"], style: TextStyle(fontSize: 20.0, height: 1.6), textAlign: TextAlign.center),
                    //Text(goodsGetList![index]["productPrice"], style: TextStyle(fontSize: 17.0, height: 1.6), textAlign: TextAlign.center)
                    //productCode, productPrice이 int로 넘어와서 String이 아니기에 오류난다 수정해야함..
                  ]
              )
            )
          );
        }
      )
    );
  }

  Scrollbar prodDetail() { //상품 설명
    return Scrollbar(
      controller: _scrollController,
      isAlwaysShown: true,
      thickness: 15,
      child: Container(
        child: Text("손 케어를 할 수 있으며 이는 매우 비싸다\n고로 난 안한다. 근데 언젠간 해볼 듯 싶지만\n내용이 어느 정도 너비를 차지하는게 좋은가", style: TextStyle(fontSize: 17.0), textAlign: TextAlign.center),
        //child: Text(_goodsVisibility ? goodsGetList![goodsSelected]["productContent"] : "test", style: TextStyle(fontSize: 20.0, height: 1.6), textAlign: TextAlign.center),
      )
    );
      Container(
      child: Text("손 케어를 할 수 있으며 이는 매우 비싸다\n고로 난 안한다. 근데 언젠간 해볼 듯 싶지만\n내용이 어느 정도 너비를 차지하는게 좋은가", style: TextStyle(fontSize: 17.0), textAlign: TextAlign.center),
      //child: Text(_goodsVisibility ? goodsGetList![goodsSelected]["productContent"] : "test", style: TextStyle(fontSize: 20.0, height: 1.6), textAlign: TextAlign.center),
    );
  }

  Container timesTitle() { //시간선택 타이틀
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Container(
            child:Text('시간선택',style: TextStyle(color: Color(0xff312B28), fontSize: 15.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Icon(Icons.refresh),
          )
        ],
      )
    );
  }

  Container timesList() { //시간 목록
    return Container(
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
                timeSelected = index;
              });
            },
            child: Container(
                width: 100,
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: (_visibility && timeSelected == index) ? Colors.transparent : Colors.blue,
                  //상품을 선택하면 하나는
                  border: Border.all(color: Colors.black),
                ),
                child: Text(timeArray[index]["time"], style: TextStyle(fontSize: 20.0, height: 1.6), textAlign: TextAlign.center)
            )
          );
        }
      )
    );
  }

  void getGoodsListData() async { //상품리스트 목록 조회
    var url = "http://172.30.1.48:8080/api/product/list?storeCode=${widget.data}"; //192.168.219.103
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String> {
        'Content-type' : 'application/json; charset=UTF-8'
      }
    );

    if (response.statusCode == 200) {
      setState(() {
        String responseBody = utf8.decode(response.bodyBytes);
        List<dynamic> testList = jsonDecode(responseBody).toList();
        goodsGetList!.addAll(testList);
        Future.delayed(Duration(milliseconds: 900), () {
          setState(() {
            _isLoading = true;
          });
        });
        print("goodsGetList?: ${goodsGetList}");
        print("response.body?: ${testList}");
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
    }
  }
}
