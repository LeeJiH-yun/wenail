import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wenail/pages/homeMain.dart';
import 'package:wenail/pages/signUpPage.dart';

void main() {
  initializeDateFormatting('ko-KR', null); //기본 언어 초기화
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
        primarySwatch: Colors.pink,
      ),
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
  String _inputId = '', _inputPw = '';

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
                keyboardType: TextInputType.text,
                onSaved: (value) {
                  setState(() {
                    _inputId = value as String;
                  });
                },
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
                keyboardType: TextInputType.visiblePassword,
                obscureText: true, //비밀번호 별표 처리하기
                onSaved: (value) {
                  setState(() {
                    _inputPw = value as String;
                  });
                },
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
                    onPressed: () => {
                      //if (_formKey.currentState!.validate()) {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => homeMain()))
                      //}
                    },
                    child: const Text("로그인")
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
                      Container(
                        child: Text("아이디찾기"),
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
}
