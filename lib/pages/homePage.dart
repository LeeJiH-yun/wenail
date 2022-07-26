import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List <String>iconList = [
    'asset/images/test1.jpg',
    'asset/images/test2.jpg',
    'asset/images/test3.jpg',
    'asset/images/test4.jpg',
    'asset/images/test5.jpg',
  ];

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
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), //이거 넣으니까 일단 스크롤은 됨..찾아봐야한다.
                itemCount: iconList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(iconList[index]),
                        fit: BoxFit.fill
                      )
                    ),
                    child: Container(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 30,
                          width: 100,
                          padding: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('예약하러가기', style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
                        ),
                      )
                    )
                  );
                },
              ),
            )
          ]
        )
      ),
    );
  }
}