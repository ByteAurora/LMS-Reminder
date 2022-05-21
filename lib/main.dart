import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:lms_reminder/manager/lms_manager.dart';
import 'package:lms_reminder/sharedpreference_key.dart';
import 'package:lms_reminder/widget/app_main_stateful.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'model/schedule.dart';

/// WorkManager를 이용하여 Background Service를 실행하기 위한 함수.
/// 실행 시 전달된 작업의 키값을 확인하여 어떤 작업인지 구분.
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'update_activities':
        // 활동 목록 업데이트 작업일 경우
        final prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString(keyUserId);
        String? userPw = prefs.getString(keyUserPw);

        if (userId != null && userId != '' && userPw != null && userPw != '') {
          // 로그인 성공한 사용자 데이터가 있을 경우
          if (await LmsManager().login(userId, userPw)) {
            await LmsManager().refreshAllData();
            Schedule? testSchedule;
            for (var schedule in LmsManager().getBeforeDeadLineList()) {
              testSchedule = schedule;
              print(schedule.toString());
            }
            await Workmanager().initialize(
              callbackDispatcher,
              isInDebugMode: true,
            );
            Workmanager().registerOneOffTask('test2', 'test2',
                existingWorkPolicy: ExistingWorkPolicy.keep, initialDelay: const Duration(seconds: 5), inputData: testSchedule!.toMap());
          } else {
            print('로그인 실패');
          }
        } else {
          print('자동로그인 비활성화');
        }
        break;
      default:
        print('Notification 실행');
        AwesomeNotifications().createNotification(content: NotificationContent(id: 10, channelKey: 'basic_channel', title: 'test', body: Schedule.fromMap(inputData!).toString()));
        break;
    }

    return Future.value(true);
  });
}

/// LMS 리마인더 main 함수.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  Workmanager().registerOneOffTask('update_activities', 'update_activities',
      existingWorkPolicy: ExistingWorkPolicy.keep, initialDelay: const Duration(seconds: 10));

  AwesomeNotifications().initialize(null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,importance: NotificationImportance.High)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true
  );

  runApp(AppMainStateful(
    applicationName: 'LMS 리마인더',
    appBarTitle: 'LMS 리마인더',
    showDebugLabel: false,
    primarySwatchColor: Colors.blue,
  ));
}
