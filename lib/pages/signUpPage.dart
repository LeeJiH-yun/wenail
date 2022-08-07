import 'package:flutter/material.dart';

class signUpPage extends StatefulWidget {
  @override
  _signUpPageState createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _inputId = '', //form 입력 값 저장
         _inputPw = '';

  void printMSG() { //회원가입 버튼 눌렀을 때 이벤트처리..
    setState(() {
      _formKey.currentState!.save();//formkey값으로 onsaved함수 호출
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
              new FlatButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
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
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "이름은 필수입니다.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "이름",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10)
                ),
              ),
              SizedBox(height: 13.0),
              TextFormField(
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "전화번호는 필수입니다.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "전화번호",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10)
                ),
              ),
              SizedBox(height: 13.0),
              Row(
                children: [
                  SizedBox(
                    width: 260,
                    child: TextFormField(
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
                        isDense: true,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10)
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0),
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text("중복체크"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(90, 40),
                      primary: Colors.deepOrange,
                    ),
                  )
                ],
              ),
              SizedBox(height: 13.0),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
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
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10)
                ),
              ),
              SizedBox(height: 13.0),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                onSaved: (value) {
                  setState(() {
                    _inputPw = value as String;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "비밀번호 확인은 필수입니다.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "비밀번호 확인",
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
}