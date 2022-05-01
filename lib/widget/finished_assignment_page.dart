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
        child: Text('완료 과제'),
      ),
    );
  }
}
