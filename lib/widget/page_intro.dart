import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:lms_reminder/main.dart';

import '../manager/lms_manager.dart';
import '../sharedpreference_key.dart';

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
              onPressed: () async {
                Workmanager().initialize(
                  callbackDispatcher,
                  isInDebugMode: true,
                );
                final prefs = await SharedPreferences.getInstance();
                String? userID = prefs.getString(keyUserId);
                String? password = prefs.getString(keyUserPw);

                if (!((userID == null || userID == "") &&
                    (password == null || password == ""))) {
                  if ((await LmsManager().login(userID!, password!))) {
                    Navigator.popAndPushNamed(context, '/main');
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("로그인 실패")));
                  }
                }
                else{
                  Navigator.popAndPushNamed(context, '/tutorial');
                }
              },
              child: Text('튜토리얼 화면 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
