import 'package:flutter/material.dart';
import 'package:lms_reminder/widget/page_intro.dart';
import 'package:lms_reminder/widget/page_login.dart';
import 'package:lms_reminder/widget/page_main.dart';
import 'package:lms_reminder/widget/page_setting.dart';
import 'package:lms_reminder/widget/page_tutorial.dart';

import '../manager/lms_manager.dart';

/// 최상위 Stateful Widget.
class AppMainStateful extends StatefulWidget {
  // 기기에서 표시될 App 이름
  final String? applicationName;

  // AppBar 제목
  final String? appBarTitle;

  // Debug 라벨 표시 여부
  final bool? showDebugLabel;

  // 기본 색상
  final MaterialColor? primarySwatchColor;

  AppMainStateful({
    Key? key,
    required this.appBarTitle,
    required this.applicationName,
    required this.showDebugLabel,
    required this.primarySwatchColor,
  }) : super(key: key);

  @override
  State<AppMainStateful> createState() => _AppMainStatefulState();
}

class _AppMainStatefulState extends State<AppMainStateful>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 디버그 라벨 표시 여부
      debugShowCheckedModeBanner: widget.showDebugLabel!,

      // AppBar에 표시될 문구.
      title: widget.applicationName!,

      // 테마.
      theme: ThemeData(
        fontFamily: 'Noto Sans KR',
        primarySwatch: widget.primarySwatchColor!,
      ),

      // 화면 이동을 위한 route.
      initialRoute: '/intro',
      routes: {
        '/intro': (context) => PageIntro(),
        '/tutorial': (context) => PageTutorial(),
        '/login': (context) => PageLogin(
            ),
        '/main': (context) => PageMain(
              appBarTitle: 'LMS 리마인더',
            ),
        '/main/setting': (context) => PageSetting(),
      },
    );
  }
}
