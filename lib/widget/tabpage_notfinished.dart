import 'package:flutter/material.dart';

class TabPageNotFinished extends StatefulWidget {
  const TabPageNotFinished({Key? key}) : super(key: key);

  @override
  State createState() {
    return _TabPageNotFinished();
  }
}

class _TabPageNotFinished extends State<TabPageNotFinished> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('미제출 과제 및 영상 목록'),
      ),
    );
  }
}
