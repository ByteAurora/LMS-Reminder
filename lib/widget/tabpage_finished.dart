import 'package:flutter/material.dart';

class TabPageFinished extends StatefulWidget {
  const TabPageFinished({Key? key}) : super(key: key);

  @override
  State createState() {
    return _TabPageFinished();
  }
}

class _TabPageFinished extends State<TabPageFinished> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('제출 과제 및 영상 목록'),
      ),
    );
  }
}
