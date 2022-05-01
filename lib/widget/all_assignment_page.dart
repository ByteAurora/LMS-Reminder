import 'package:flutter/material.dart';

class AllAssignmentPage extends StatefulWidget {
  const AllAssignmentPage({Key? key}) : super(key: key);

  @override
  State createState() {
    return _AllAssignmentPage();
  }
}

class _AllAssignmentPage extends State<AllAssignmentPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('모든 과제 목록 표시'),
      ),
    );
  }
}
