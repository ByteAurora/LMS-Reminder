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

  final LmsManager lmsManager = LmsManager();

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
      debugShowCheckedModeBanner: widget.showDebugLabel!,
      title: widget.applicationName!,
      theme: ThemeData(
        fontFamily: 'Noto Sans KR',
        primarySwatch: widget.primarySwatchColor!,
      ),
      initialRoute: '/intro',
      routes: {
        '/intro': (context) => PageIntro(),
        '/tutorial': (context) => PageTutorial(),
        '/login': (context) => PageLogin(
              lmsManager: widget.lmsManager,
            ),
        '/main': (context) => PageMain(
              appBarTitle: 'LMS 리마인더',
              lmsManager: widget.lmsManager,
            ),
        '/main/setting': (context) => PageSetting(),
      },
    );
  }
}
