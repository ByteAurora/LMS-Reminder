import 'package:flutter/material.dart';

import 'widget/app_main_stateless.dart';

/// LMS 리마인더 main 함수.
void main() {
  runApp(const AppMainStateless(
    applicationName: 'LMS 리마인더',
    appBarTitle: 'LMS 리마인더',
    showDebugLabel: false,
    primarySwatchColor: Colors.blue,
  ));
}
