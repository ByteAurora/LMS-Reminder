import 'package:flutter/material.dart';
import 'package:lms_reminder/widget/app_main_stateful.dart';

/// LMS 리마인더 main 함수.
void main() {
  runApp(AppMainStateful(
    applicationName: 'LMS 리마인더',
    appBarTitle: 'LMS 리마인더',
    showDebugLabel: false,
    primarySwatchColor: Colors.blue,
  ));
}
