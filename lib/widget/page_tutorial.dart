import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

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
                // Workmanager().registerPeriodicTask(
                //   'test_key',
                //   'test_key',
                //   initialDelay: Duration(seconds: 10),
                //   frequency: Duration(seconds: 15),
                // );
                Workmanager().cancelByUniqueName('test_key');
                Navigator.popAndPushNamed(context, '/login');
              },
              child: Text('로그인 화면 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
