import 'package:flutter/material.dart';

class TabPageNotice extends StatefulWidget {
  const TabPageNotice({Key? key}) : super(key: key);

  @override
  State createState() {
    return _TapPageNotice();
  }
}

class _TapPageNotice extends State<TabPageNotice> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('공지사항 목록 표시'),
      ),
    );
  }
}
