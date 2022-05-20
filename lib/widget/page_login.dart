import 'package:flutter/material.dart';
import 'package:lms_reminder/manager/lms_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sharedpreference_key.dart';

class PageLogin extends StatefulWidget {
  final LmsManager lmsManager;

  const PageLogin({Key? key, required this.lmsManager}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  ///id 컨트롤
  TextEditingController userID = TextEditingController();
  String? keepID='';
  ///pw 컨트롤
  TextEditingController password = TextEditingController();
  String? keepPW='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: userID,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey,
                    labelText: 'ID',
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey,
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString(keyUserId, userID.text);
                prefs.setString(keyUserPw, password.text);
                keepID = prefs.getString(keyUserId);
                keepPW = prefs.getString(keyUserPw);
                if ((await LmsManager().login(keepID!, keepPW!))) {
                  Navigator.popAndPushNamed(context, '/main');
                }
                else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("로그인 실패")));
                }
              },
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }

}
