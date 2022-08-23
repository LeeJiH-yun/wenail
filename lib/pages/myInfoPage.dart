import 'package:flutter/material.dart';

class myInfoPage extends StatefulWidget {
  @override
  _myInfoState createState() => _myInfoState();
}

class _myInfoState extends State<myInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("내정보수정", style: TextStyle(color: Color(0xffF7D6AD))),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.fromLTRB(20, 100, 20, 120),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "test",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10)
                ),
              ),
              SizedBox(height: 13.0),
              TextField(
                decoration: InputDecoration(
                  hintText: "01011112222",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10)
                ),
              ),
              SizedBox(height: 13.0),
              TextField(
                decoration: InputDecoration(
                    hintText: "test 아이디",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10)
                ),
              ),
              SizedBox(height: 13.0),
              TextField(
                decoration: InputDecoration(
                  hintText: "1234 비밀번호",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10)
                ),
              ),
              SizedBox(height: 13.0),
              TextField(
                decoration: InputDecoration(
                  hintText: "1234 확인비밀번호",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10)
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
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
                                Text("수정이 완료되었습니다"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: new Text("확인"),
                                onPressed: () {
                                  Navigator.of(context).pop(); Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }
                      );
                    });
                  },
                  child: Text("수정하기", style: TextStyle(color: Color(0xffF7D6AD)))
                ),
              ),
            ]
          )
      ),
    );
  }
}