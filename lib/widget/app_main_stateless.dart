import 'package:flutter/material.dart';

import 'app_main_stateful.dart';

/// 최상위 Stateless Widget.
class AppMainStateless extends StatelessWidget {
  // 기기에서 표시될 App 이름
  final String? applicationName;

  // AppBar 제목
  final String? appBarTitle;

  // Debug 라벨 표시 여부
  final bool? showDebugLabel;

  // 기본 색상
  final MaterialColor? primarySwatchColor;

  const AppMainStateless(
      {Key? key,
      required this.applicationName,
      required this.appBarTitle,
      required this.showDebugLabel,
      required this.primarySwatchColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: showDebugLabel!,
      title: applicationName!,
      theme: ThemeData(
        primarySwatch: primarySwatchColor!,
      ),
      home: AppMainStateful(appBarTitle: appBarTitle!),
    );
  }
}
