import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sharedpreferences_key.dart';

class ScreenTutorial extends StatefulWidget {
  const ScreenTutorial({Key? key}) : super(key: key);

  @override
  State<ScreenTutorial> createState() {
    return _ScreenTutorialState();
  }
}

class _ScreenTutorialState extends State<ScreenTutorial> {
  /// 튜토리얼을 완료했을 경우 다시 튜토리얼을 실행하지 않도록 판단하는 키값(keyNotificationId)를 true로 바꾸는 함수.
  Future<void> tutorialGraduate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(keyTutorialShowed, true);
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
        // 페이지마다 디자인 설정.
        titleTextStyle: TextStyle(
            fontSize: 1.0, fontWeight: FontWeight.w700, color: Colors.white),
        bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        imageFlex: 4,
        bodyFlex: 2,
        imagePadding: EdgeInsets.zero,
        imageAlignment: Alignment.bottomCenter);

    return IntroductionScreen(
      pages: [
        PageViewModel(
          // 튜토리얼 첫번쨰 페이지.
          title: " .",
          body: "LMS 리마인더로 수강중인 강좌의 강의 및 과제를 쉽게 확인해보세요",
          image: Image.asset("resource/image/image_tutorial_01.png",
              width: 350, height: 350, fit: BoxFit.contain),
          decoration: pageDecoration,
        ),
        PageViewModel(
          // 튜토리얼 두번쨰 페이지.
          title: ".",
          body: "아직 시청하지 않은 강의나 제출하지 않은 과제가 있으면 LMS 리마인더가 알려줍니다",
          image: Image.asset("resource/image/image_tutorial_02.png",
              width: 300, height: 300, fit: BoxFit.contain),
          decoration: pageDecoration,
        ),
        PageViewModel(
          // 튜토리얼 세번쨰 페이지.
          title: ".",
          body: "수강중인 강좌의 중요한 공지사항을 확인해보세요",
          image: Image.asset("resource/image/image_tutorial_03.png",
              width: 300, height: 300, fit: BoxFit.contain),
          decoration: pageDecoration,
        ),
      ],
      done: const Text("시작하기", style: TextStyle(color: Colors.black)),
      showBackButton: false,
      showSkipButton: true,
      skip: const Text("건너뛰기",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
      onSkip: () {
        //튜토리얼 스킵.
        tutorialGraduate();
        Navigator.popAndPushNamed(context, '/login');
      },
      onDone: () {
        //튜토리얼 완료
        tutorialGraduate();
        Navigator.popAndPushNamed(context, '/login');
      },
      globalBackgroundColor: Colors.white,
      next: Image.asset("resource/image/icon_next.png", // 넥스트(>모양)색.
          color: const Color.fromARGB(0xff, 070, 070, 070),
          width: 15,
          height: 15),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: const Color.fromARGB(0xff, 070, 070, 070),
        // 선택된 탭.
        color: const Color.fromARGB(0xff, 235, 235, 235),
        // 선택되지 않은 탭.
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
