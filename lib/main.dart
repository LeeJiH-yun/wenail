import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  var _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.fromLTRB(20, 120, 20, 120),
        child: Column(
          children: <Widget>[
              // Container( //버전관리
              //   width: MediaQuery.of(context).size.width,
              //   child: Text("ver1.0"),
              // ),
              Container(//앱 메인 이미지
                child: Image.asset('asset/images/logo_nail1.png', width: 100, height: 100, fit: BoxFit.fill),
              ),
              SizedBox(height: 45.0), //사이 공백
              TextFormField( //값을 일력받을 수 있는 폼
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "아이디",
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 13.0), //사이 공백
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "비밀번호",
                    border: OutlineInputBorder()
                ),
              ),
              //SizedBox(height: 13.0), //사이 공백
              Row( //너무 옆으로 띄워진거 수정해야함
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
                padding: const EdgeInsets.only(top: 8.0), // 8단위 배수가 보기 좋음
                child: ElevatedButton(
                    onPressed: () => {},
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
                      //color: Colors.blue,
                      child: Text("비밀번호찾기"),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: Colors.orange,
                    ),
                    Container(
                      //color: Colors.yellow,
                      child: Text("아이디찾기"),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: Colors.orange,
                    ),
                    Container(
                      //color: Colors.green,
                      child: Text("회원가입"),
                    ),
                  ],
                )
              )
          ]
        )
      )
    );
  }
}
