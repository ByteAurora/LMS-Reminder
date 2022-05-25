import 'package:flutter/material.dart';
import 'package:lms_reminder/manager/lms_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sharedpreferences_key.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({Key? key}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> with SingleTickerProviderStateMixin  {
  ScrollController?
      _scrollController; // 스크롤컨트롤러 : 후에 키보드창이떴을때, 스크롤을 위로해줘서 유저경험(UX)를 향상시키기 위함.
  double? _deviceWidth, _deviceHeight; //사용자의 화면크기 비율을 정하기 위해, 사용자 화면 크기를 가져오면 변수.

  // 애니메이션을 설정한 Controller


  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
  }

  void scrollTo(String str) {
    // 스크롤 위 아래로 올려주는 함수.
    if (str == "up") {
      //화면 위로 올리기
      _scrollController!.animateTo(120.0,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    } else if (str == "down") {
      // 화면 아래로 내리기
      _scrollController!.animateTo(-120.0,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose(); //메모리릭을 방지하기 위한 컨트롤러 닫기
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  ///id 컨트롤
  TextEditingController userID = TextEditingController();
  String? keepID = '';

  ///pw 컨트롤
  TextEditingController password = TextEditingController();
  String? keepPW = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, //화면 위로 키보드가 올라옴.
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
              fit: BoxFit.fitHeight,
              image: AssetImage('resource/image/login_bg.png')), // 배경 이미지
        ),
        child: Center(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // 상하 정렬 중앙정렬로
              crossAxisAlignment: CrossAxisAlignment.center, //좌우 정렬 왼쪽으로
              children: <Widget>[
                //로고 이미지 컨테이너
                Container(
                  //비율이 2로 설정( 로고 이미지부분)

                  height: _deviceHeight! / 5 * 2, //화면 비율을 2:3으로 하기 위함.
                  child: Column(
                    //절대값 Expanded안에 작은 위젯(Container>ClipRRect>image)을 넣기 위함.
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'logolag',
                        child: Container(
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
                      ),
                    ],
                  ),
                ),
            Container(
              height: _deviceHeight! / 5 * 4,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                            // 왼쪽정렬을 위해 사이즈박스를 넣음(텍스트필드 크기의 기본값은 wrap.contents이므로

                            child: Text(
                          "로그인",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        )),
                        SizedBox(
                          height: 30,
                        ),
                        Text("아이디"),
                        TextField(
                          controller: userID,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Colors.grey,
                            hintText: "아이디",

                          ),
                        ),
                        SizedBox(height: 10.0), //여백넣기
                        Text("비밀번호"),
                        TextField(
                          obscureText: true,
                          controller: password,
                          onTap: () {
                            // 비밀번호 클릭시 스크롤을 올려서 입력중인 비밀번호 텍스트필드가 가려지는거 방지
                            //scrollTo("up");
                          },
                          onSubmitted: (str) {
                            scrollTo("down");
                          },
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
                              scrollTo("down");
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              //입력된 값이 비어있지 않으면
                              if (userID.text.isNotEmpty &&
                                  password.text.isNotEmpty) {
                                //로그인 후 id와 password 값을 저장
                                if ((await LmsManager()
                                    .login(userID.text, password.text))) {
                                  prefs.setString(keyUserId, userID.text);
                                  prefs.setString(keyUserPw, password.text);
                                  Navigator.popAndPushNamed(
                                      context, '/main');
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text("로그인 실패")));
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
                                    borderRadius:
                                        BorderRadius.circular(12))),
                          ),
                        ),
                      ])),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
