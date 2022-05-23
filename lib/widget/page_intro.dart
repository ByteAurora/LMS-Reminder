import 'package:flutter/material.dart';
import 'package:lms_reminder/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../manager/lms_manager.dart';
import '../sharedpreference_key.dart';

class PageIntro extends StatefulWidget {
  const PageIntro({Key? key}) : super(key: key);

  @override
  State<PageIntro> createState() => _PageIntroState();
}

class _PageIntroState extends State<PageIntro> {
  String? userID;
  String? password;

  @override
  void initState() {
    super.initState();
    _loadLogin();
  }

  _loadLogin() async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    setState((){
      pref.setString(keyUserId, "");
      pref.setString(keyUserPw, "");
    });
  }
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
                final prefs = await SharedPreferences.getInstance();
                userID = prefs.getString(keyUserId);
                password = prefs.getString(keyUserPw);
                bool? tutorialShowed = prefs.getBool(keyTutorialShowed);

                if (!tutorialShowed!) {
                  //튜토리얼을 본적이 없을 경우
                  Navigator.popAndPushNamed(
                      context, '/tutorial'); //튜토리얼 페이지로 이동
                } else {
                  //튜토리얼을 완료 경우
                  if (!((userID == null || userID == "") &&
                      (password == null || password == ""))) {
                    // 저장된 아이디나 비밀번호가 있을 경우
                    if ((await LmsManager().login(
                        userID!, password!))) { // 저장된 값으로 로그인 진행
                      Navigator.popAndPushNamed(
                          context, '/main'); //자동로그인후 메인으로 이동
                    } else { //저장된 ID/PW로 로그인이 실패할 경우
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                          SnackBar(content: Text("로그인 실패"))); //로그인 실패 팝업
                      Navigator.popAndPushNamed(
                          context, '/login'); // 로그인 페이지로 이동
                    }
                  } else { //저장된 ID/PW가 없을 경우
                    Navigator.popAndPushNamed(context, '/login');
                  }
                }
              },
              child: const Text('튜토리얼 화면 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
