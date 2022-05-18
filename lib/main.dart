import 'package:flutter/material.dart';
import 'package:lms_reminder/widget/app_main_stateful.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'test_key':
        print("was executed. inputData = $inputData");
        break;
    }

    return Future.value(true);
  });
}

/// LMS 리마인더 main 함수.
void main() async {
  runApp(AppMainStateful(
    applicationName: 'LMS 리마인더',
    appBarTitle: 'LMS 리마인더',
    showDebugLabel: false,
    primarySwatchColor: Colors.blue,
  ));
}
