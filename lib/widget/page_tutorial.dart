import 'package:flutter/material.dart';

class PageTutorial extends StatefulWidget {
  const PageTutorial({Key? key}) : super(key: key);

  @override
  State<PageTutorial> createState() => _PageTutorialState();
}

class _PageTutorialState extends State<PageTutorial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('튜토리얼 화면'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('로그인 화면 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
