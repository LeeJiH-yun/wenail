import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            Container(//앱 메인 이미지
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.grey,
              child: Text("광고란"),
            ),
            SizedBox(height: 15.0),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "네일샵 검색",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8)
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Icon(Icons.search, size: 45.0),
                  ),
                  // ElevatedButton.icon( //검색버튼 2번째 방법
                  //   onPressed: () => {},
                  //   icon: Icon(Icons.search_sharp),
                  //   label: Text(""),
                  //   style: ElevatedButton.styleFrom(
                  //     fixedSize: Size(50, 50),
                  //   ),
                  // )
                ],
              )
            ),
            SizedBox(height: 13.0),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Container( //목록 스크롤..
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 100,
                      itemBuilder: (BuildContext context, int index) {
                        return Text('Row $index');
                      },
                    ),
                  )
                ],
              )
            )
          ]
        )
      ),
    );
  }
}