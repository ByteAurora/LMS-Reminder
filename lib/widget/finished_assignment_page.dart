import 'package:flutter/material.dart';

class FinishedAssignmentPage extends StatefulWidget {
  const FinishedAssignmentPage({Key? key}) : super(key: key);

  @override
  State createState() {
    return _FinishedAssignmentPage();
  }
}

class _FinishedAssignmentPage extends State<FinishedAssignmentPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('제출한 과제 목록 표시'),
      ),
    );
  }
}
