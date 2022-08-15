import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class signUpPage extends StatefulWidget {
  @override
  _signUpPageState createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController pwChkController = TextEditingController();

  void printMSG() { //회원가입 버튼 눌렀을 때 이벤트처리..
    setState(() {
      getJSONData(); //입력받은 데이터 서버로 보내기
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
                Text("회원가입 성공!"),
              ],
            ),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); Navigator.of(context).pop();
                  //첫번째 pop은 알림창 닫고 두번째 pop은 이전 화면으로 돌려준다.
                },
              ),
            ],
          );
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.fromLTRB(20, 100, 20, 120),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "이름은 필수입니다.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "* 이름",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10)
                ),
              ),
              SizedBox(height: 13.0),
              TextFormField(
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "전화번호는 필수입니다.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "* 전화번호",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10)
                ),
              ),
              SizedBox(height: 13.0),
              TextButton(
                onPressed: () {
                //   Future<DateTime> future = showDatePicker(
                //     context: context,
                //     initialDate: DateTime.now(),
                //     firstDate: DateTime(1970),
                //     lastDate: DateTime.now(),
                //     locale : const Locale('kr')
                //   );
                //
                //   future.then((date) {
                //     setState(() {
                //       _selectedDate = date;
                //     });
                //   });
                },
                child: Container(
                  height: 45,
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Color(0xff312B28),
                    )),
                  alignment: Alignment.centerLeft,
                  child: Text('생일 선택', style: TextStyle(color: Color(0xff312B28))),
                ),
              ),
              SizedBox(height: 13.0),
              Row(
                children: [
                  SizedBox(
                    width: 260,
                    child: TextFormField(
                      controller: idController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "아이디는 필수입니다.";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "* 아이디",
                        isDense: true,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10)
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0),
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text("중복체크", style: TextStyle(color: Color(0xffF7D6AD))),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(90, 40),
                      primary: Colors.brown,
                    ),
                  )
                ],
              ),
              SizedBox(height: 13.0),
              TextFormField(
                controller: pwController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "비밀번호는 필수입니다.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "* 비밀번호",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10)
                ),
              ),
              SizedBox(height: 13.0),
              TextFormField(
                controller: pwChkController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "비밀번호 확인은 필수입니다.";
                  }
                  else if (pwChkController.text != pwController.text) {
                    return "비밀번호가 일치하지 않습니다.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "* 비밀번호 확인",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10)
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () => {
                    if (_formKey.currentState!.validate()) {
                      printMSG()
                    }
                  },
                  child: Text("회원가입")
                ),
              ),
            ]
          ),
        )
      )
    );
  }

  Future<String> getJSONData() async { //회원가입 데이터 보내기
    var url = "http://192.168.219.103:8080/api/user/save";

    Map<String, String> data = {
      "birthDate": "19971115",
      "userId": idController.text,
      "userMobile": phoneController.text,
      "userName": nameController.text,
      "userPassword": pwController.text,
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
      print(response.body);
    }
    else {
      print("failed to save data");
    }
    return response.body;
  }
}