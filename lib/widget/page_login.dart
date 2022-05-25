import 'package:flutter/material.dart';
import 'package:lms_reminder/manager/lms_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sharedpreferences_key.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({Key? key}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  ///id 컨트롤
  TextEditingController userID = TextEditingController();
  String? keepID = '';

  ///pw 컨트롤
  TextEditingController password = TextEditingController();
  String? keepPW = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //키보드가 나오면서 화면이 깨지는 현상 방지
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black12,BlendMode.darken),
                fit: BoxFit.cover,
                image: AssetImage('resource/image/login_bg.png')), // 배경 이미지

            ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 상하 정렬 중앙정렬로
            crossAxisAlignment: CrossAxisAlignment.center, //좌우 정렬 왼쪽으로
            children: <Widget>[
              //로고 이미지 컨테이너
              Expanded(
                //비율이 2로 설정( 로고 이미지부분)
                flex: 2,
                child: Column(
                  //절대값 Expanded안에 작은 위젯(Container>ClipRRect>image)을 넣기 위함.
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      // 이미지를 감싸는 컨테이너
                      child: ClipRRect(
                        //이미지 모서리를 둥글게하기 위한 위젯
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          //로고_이미지
                          "resource/image/icon_lmsreminder.png",
                          fit: BoxFit.contain,
                          width: 150,
                          height: 150,
                        ),
                      ),
                      decoration: BoxDecoration(
                        //그림자를 넣는 속성
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0,
                          ),
                          BoxShadow(
                            color: Colors.white24,
                            offset: Offset(-4.0, -4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                // 비율 3인 로고 이미지 부분
                flex: 3,
                  child: Container(
                      // 로고이미지 컨테이터외
                      // 로그인, 아이디,비밀번호 textfield와 text, 버튼 위젯을 담는 컨테이너

                      decoration: BoxDecoration(
                        //윗 모서리를 둥굴게 설정
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30), //모서리 둥글게
                        ),
                        boxShadow: [
                          //그림자설정
                          BoxShadow(
                            color: Colors.grey[500]!,
                            offset: Offset(-2.0, -4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      //로그인아이디와 비밀번호,
                      padding: EdgeInsets.all(40),
                      child: Column(
                          // 중앙정렬을 위한 컬럼
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                                // 왼쪽정렬을 위해 사이즈박스를 넣음(텍스트필드 크기의 기본값은 wrap.contents이므로
                                width: double.infinity,
                                child: Text(
                                  "로그인하세요.",
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                            Spacer(),
                            Text("아이디"),
                            TextField(
                              controller: userID,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.grey,
                                hintText: "아이디",
                              ),
                            ),
                            SizedBox(height: 10.0), //여 백넣기
                            Text("비밀번호"),
                            TextField(
                              obscureText: true,
                              controller: password,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.grey,
                                //labelText: 'Password',
                                hintText: "비밀번호",
                              ),
                            ),

                            //버튼을 담을 컨테이너

                            Container(
                              margin: EdgeInsets.only(top: 40),
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences prefs= await SharedPreferences.getInstance();
                                  //입력된 값이 비어있지 않으면
                                  if(userID.text.isNotEmpty && password.text.isNotEmpty){
                                    //로그인 후 id와 password 값을 저장 
                                    if ((await LmsManager()
                                        .login(userID.text, password.text))) {
                                      prefs.setString(keyUserId, userID.text);
                                      prefs.setString(keyUserPw, password.text);
                                      Navigator.popAndPushNamed(context, '/main');
                                    }
                                    else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("로그인 실패")));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("정보를 입력해주세요")));
                                  }
                                },
                                child: Text(
                                  '로그인',
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary:
                                        Color.fromARGB(0xff, 0xB7, 0x21, 0x2D),
                                    minimumSize: Size(200, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12))),
                              ),
                            ),
                          ])),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
