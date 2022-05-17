import 'package:flutter/material.dart';
import 'package:lms_reminder/manager/lms_manager.dart';

class PageLogin extends StatefulWidget {
  final LmsManager lmsManager;

  const PageLogin({Key? key, required this.lmsManager}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  ///id변수
  TextEditingController userID = TextEditingController();
  ///pw변수
  TextEditingController password = TextEditingController();

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
                ),
              ),
            ),
            Text('로그인 화면'),
            ElevatedButton(
              onPressed: () async {

                if ((await LmsManager().login(userID.text, password.text))) {
                  Navigator.popAndPushNamed(context, '/main');
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("로그인 실패")));
                }
              },
              child: Text('메인 화면 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
