import 'package:flutter/material.dart';

class idSearch extends StatefulWidget {
  @override
  _idSearchState createState() => _idSearchState();
}

class _idSearchState extends State<idSearch> {
  bool _visibility = false; //인증번호 입력칸 보이기 여부

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("아이디찾기"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.fromLTRB(20, 100, 20, 120),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "이름을 입력하세요.",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10)
              ),
            ),
            SizedBox(height: 13.0),
            TextField(
              decoration: InputDecoration(
                hintText: "전화번호를 입력하세요.",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10)
              ),
            ),
            SizedBox(height: 13.0),
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _visibility = true;
                  });
                },
                child: const Text("인증번호 전송")
              ),
            ),
            SizedBox(height: 13.0),
            Visibility( //인증번호 입력란
              visible: _visibility,
              child: ChkNumber()
            ),
          ]
        )
      )
    );
  }

  Row ChkNumber() {
    return Row(
      children: [
        SizedBox(
          width: 260,
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: "인증번호를 입력하세요.",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10)
            ),
          ),
        ),
        SizedBox(width: 15.0),
        ElevatedButton(
          onPressed: () {
            setState(() {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("아이디는"),
                        Text("dlld1113 입니다.")
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
                }
              );
            });
          },
          child: Text("인증완료"),
          style: ElevatedButton.styleFrom(
            fixedSize: Size(90, 40),
            primary: Colors.deepOrange,
          ),
        )
      ],
    );
  }
}