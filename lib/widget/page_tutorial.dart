
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:workmanager/workmanager.dart';

class PageTutorial extends StatefulWidget {
  const PageTutorial({Key? key}) : super(key: key);

  @override
  State<PageTutorial> createState() => _PageTutorialState();
}

class _PageTutorialState extends State<PageTutorial> {
   //내 최애 빨강색 >_<

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 1.0, fontWeight: FontWeight.w700,color: Colors.white),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),

      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      pages:
      [
        PageViewModel(

        title: "LMS리마인더로 수강중인 과목의 강의 및 과제를 쉽게 확인해보세요.",
        body: "LMS리마인더로 수강중인 과목의 강의 및 과제를 쉽게 확인해보세요.",
        image: Image.asset("resource/image/image_todo.png",width: 300,height: 200,fit: BoxFit.contain,),
        decoration: pageDecoration,

      ),
        PageViewModel(
          title: "Fractional shares",
          body:
          "아직 시청하지 않은 강의나 제출하지 않은 과제가 있으면 LMS 리마인더가 알려줍니다.",
          image: Image.asset("resource/image/icon_video.png"),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Fractional shares",
          body:
          "수강중인 과목의 중요한 공지사항을 \n확인해보세요",
          image: Image.asset("resource/image/icon_video.png"),
          decoration: pageDecoration,
        ),
      ],

      done: const Text("시작하기", style: TextStyle(fontWeight: FontWeight.w600,color: Color.fromARGB(0xff, 070, 070, 070))),
      showBackButton: false,
      showSkipButton: true,
      skip: const Text("건너뛰기",style: TextStyle(fontWeight: FontWeight.w600,color: Color.fromARGB(0xff, 070, 070, 070))),
      onSkip: (){ Navigator.popAndPushNamed(context, '/login');},
      onDone: () { Navigator.popAndPushNamed(context, '/login');},
      globalBackgroundColor: Colors.white,
      next: Image.asset("resource/image/icon_next.png", //> 색
          color: Color.fromARGB(0xff, 070, 070, 070),
          width: 15, height: 15),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Color.fromARGB(0xff, 070, 070, 070), //선택된 탭
        color: Color.fromARGB(0xff, 235, 235, 235), //안선택된 탭
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0)
    )),
    );
  }

}
