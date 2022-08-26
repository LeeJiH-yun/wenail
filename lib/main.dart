import 'dart:convert';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:wenail/pages/homeMain.dart';
import 'package:wenail/pages/idSearchPage.dart';
import 'package:wenail/pages/signUpPage.dart';

//백그라운드에서 메시지 수신 시
Future<void> _backGroundMsg(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

Future<void> firebaseInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase 초기화부터 해야 Firebase Messaging 을 사용할 수 있다.
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backGroundMsg);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  messaging.getToken().then((value) {
    print("메세지 토큰??"); //받는 사용자 토큰 값 가져오기
    print(value);
  });

  //포그라운드에있을 때 들어오는 FCM 페이로드가 수신 될 때 호출되는 스트림을 반환
  //앱 키고 있을 때 메세지 뜨게
  FirebaseMessaging.onMessage.listen(
        (RemoteMessage event) {
      print("메세지 받는다. message recieved");
      print(event.notification!.body);
      showMyDialog(event.notification!);
    },
  );
//Background에서 클릭하여 들어올때 페이지 이동할 곳 여기에 쓰면 될듯
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('메세지 클릭 Message clicked!');
  });
}

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await firebaseInit();
  // initializeDateFormatting('ko-KR', null); //기본 언어 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      //home: MainHome(),
      home: AnimatedSplashScreen(
        splash: Image.asset('asset/images/ic_nail.png'),
        nextScreen: MainHome(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
        duration: 2000
      ),
      navigatorKey: navigatorKey, //이거 확실하게 알아보기
    );
  }
}

//앱 안(포그라운드)에서 푸시를 수신한 경우
final navigatorKey = GlobalKey<NavigatorState>();
void showMyDialog(RemoteNotification notification) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(notification.title.toString()),
        content: Text(notification.body.toString()),
        actions: [
          TextButton(
            child: const Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
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

  void _startLoading(codeNum, data) async {
    setState(() {
      if (200 == codeNum) { //로그인 성공
        Future.delayed(Duration(milliseconds: 900), () {
          setState(() {
            _isLoading = false;
          });
        });
        Future.delayed(Duration(milliseconds: 1000), () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => homeMain(data)));
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
                child: Image.asset('asset/images/logo_nail.png', width: 100, height: 100, fit: BoxFit.fill),
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
                      //Navigator.push(context,MaterialPageRoute(builder: (context) => homeMain()));
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
    var url = "http://192.168.219.103:8080/api/user/login"; //집와이파이 192.168.219.103

    Map<String, String> data = { //입력받은 데이터를 넣는다.
      "userId": idController.text,
      "userPassword": pwController.text,
      "uidToken": token.toString()
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
      _startLoading(200, response.body);
      print(response.body);
    }
    else {
      _startLoading(500, response.body);
      print("failed to login");
    }
    return response.body;
  }
}
