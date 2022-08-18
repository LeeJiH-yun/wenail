import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wenail/pages/homeMain.dart';
import 'package:wenail/pages/idSearchPage.dart';
import 'package:wenail/pages/signUpPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // initializeDateFormatting('ko-KR', null); //기본 언어 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //우측 상단의 디버그 표시를 없앤다.
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ko', 'KO'),
      ],
      locale: const Locale('ko'),
      home: MainHome(),
    );
  }
}

class MainHome extends StatefulWidget {
  @override
  MainHomeState createState() => MainHomeState();
}

class MainHomeState extends State<MainHome> {
  final _formKey = GlobalKey<FormState>();
  var _isChecked = false;
  bool _isLoading = false;

  //특정 이벤트가 발생하였을 때, 현재 입력된 값에 접근하고 싶을 때 TextEditingController 사용.
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  void _startLoading(codeNum) async {
    setState(() {
      if (200 == codeNum) { //로그인 성공
        Future.delayed(Duration(milliseconds: 900), () {
          setState(() {
            _isLoading = false;
          });
        });
        Future.delayed(Duration(milliseconds: 1000), () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => homeMain()));
        });
      }
      else { //로그인 실패
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("계정이 존재하지 않습니다.\n다시 시도해주시기 바랍니다."),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("확인"),
                  onPressed: () {
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.fromLTRB(20, 120, 20, 120),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(//앱 메인 이미지
                child: Image.asset('asset/images/logo_nail1.png', width: 100, height: 100, fit: BoxFit.fill),
              ),
              SizedBox(height: 45.0), //사이 공백
              TextFormField( //값을 입력받을 수 있는 폼
                controller: idController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "아이디는 필수입니다.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "아이디",
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 13.0), //사이 공백
              TextFormField(
                controller: pwController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true, //비밀번호 별표 처리하기
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "비밀번호는 필수입니다.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "비밀번호",
                  border: OutlineInputBorder()
                ),
              ),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!; //value값이 오류나서 임시방편으로 수정
                        });
                      }
                    ),
                  ),
                  Text("자동로그인"),
                ],
              ),
              Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var token = await FirebaseMessaging.instance.getToken(); //사용자 토큰값 구하기
                      print("token : ${token ?? 'token NULL!'}");
                      Navigator.push(context,MaterialPageRoute(builder: (context) => homeMain()));
                      setState(() {
                        _isLoading = true;
                      });
                      setLoginData(token);
                    }
                  },
                  child: _isLoading ? CircularProgressIndicator(color: Color(0xffF7D6AD), strokeWidth: 3.0) : Text("로그인", style: TextStyle(color: Color(0xffF7D6AD)))
                ),
              ),
              SizedBox(height: 5.0), //사이 공백
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              SizedBox(height: 11.0), //사이 공백
              IntrinsicHeight(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("비밀번호찾기"),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: Colors.orange,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => idSearch()));
                      },
                      child: Container(
                        child: Text("아이디찾기"),
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: Colors.orange,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => signUpPage()));
                      },
                      child: Container(
                        child: Text("회원가입"),
                      ),
                    )
                  ],
                )
              )
            ]
          ),
        )
      )
    );
  }

  Future<String> setLoginData(token) async { //로그인 시도
    var url = "http://192.168.219.103/api/user/login"; //집와이파이 192.168.219.103

    Map<String, String> data = { //입력받은 데이터를 넣는다.
      "userId": idController.text,
      "userPassword": pwController.text,
      "token": token.toString()
    };
    var bodys = json.encode(data);

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String> {
        'Content-type' : 'application/json; charset=UTF-8'
      },
      body: bodys
    );
    print(response.body);

    if (response.statusCode == 200) {
      _startLoading(200);
      print(response.body);
    }
    else {
      _startLoading(500);
      print("failed to login");
    }
    return response.body;
  }
}
