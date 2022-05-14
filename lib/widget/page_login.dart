import 'package:flutter/material.dart';
import 'package:lms_reminder/manager/lms_manager.dart';

class PageLogin extends StatefulWidget {
  final LmsManager lmsManager;

  const PageLogin({Key? key, required this.lmsManager}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('로그인 화면'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/main');
              },
              child: Text('메인 화면 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
