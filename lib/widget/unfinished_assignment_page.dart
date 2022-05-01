import 'package:flutter/material.dart';

class UnfinishedAssignmentPage extends StatefulWidget {
  const UnfinishedAssignmentPage({Key? key}) : super(key: key);

  @override
  State createState() {
    return _UnfinishedAssignmentPage();
  }
}

class _UnfinishedAssignmentPage extends State<UnfinishedAssignmentPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('미제출한 과제 목록 표시'),
      ),
    );
  }
}