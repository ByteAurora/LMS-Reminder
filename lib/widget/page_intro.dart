import 'package:flutter/material.dart';

class PageIntro extends StatefulWidget {
  const PageIntro({Key? key}) : super(key: key);

  @override
  State<PageIntro> createState() => _PageIntroState();
}

class _PageIntroState extends State<PageIntro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('인트로 화면'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tutorial');
              },
              child: Text('튜토리얼 화면 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
