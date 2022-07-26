import 'package:flutter/material.dart';

class myPage extends StatefulWidget {
  @override
  _myPageState createState() => _myPageState();
}

class _myPageState extends State<myPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () => {
          Navigator.pop(context)
        },
        child: Icon(Icons.logout)
      )
    );
  }
}