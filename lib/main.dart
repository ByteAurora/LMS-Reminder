import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms_reminder/manager/lms_manager.dart';
import 'package:lms_reminder/sharedpreferences_key.dart';
import 'package:lms_reminder/widget/app_main_stateful.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'model/schedule.dart';

/// WorkManager를 이용하여 Background Service를 실행하기 위한 함수. 실행 시 전달된 작업의 키값(매개변수 task)을 확인하여 어떤 작업인지 구분.
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'update_activities':
        // 활동 목록 업데이트 작업일 경우.
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(keyLastUpdateTime,
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));

        String? userId = prefs.getString(keyUserId);
        String? userPw = prefs.getString(keyUserPw);

        if (!(await LmsManager().checkLoginState())) {
          if (userId != null &&
              userId != '' &&
              userPw != null &&
              userPw != '') {
            // 로그인 성공한 사용자 데이터가 있을 경우.

            if (await LmsManager().login(userId, userPw)) {
              // 데이터 업데이트 Notification 표시.
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                      id: 0,
                      channelKey: 'update_activities',
                      wakeUpScreen: false,
                      summary: '업데이트',
                      title: 'LMS에서 과제와 동영상을 확인하고 있습니다',
                      backgroundColor: Colors.redAccent,
                      notificationLayout: NotificationLayout.ProgressBar,
                      autoDismissible: true));

              // LMS에서 데이터 불러오기.
              await LmsManager().reloadAllDataFromLms();

              // WorkManager 추가 전 초기화.
              await Workmanager().initialize(
                callbackDispatcher,
                isInDebugMode: false,
              );

              // 이전에 설정된 모든 알림 제거 - 사용자가 바뀌었을 경우도 있기 때문에 WorkManager의 replace만으로는 해결 불가.
              // 추후 WorkManager에 사용자 ID값도 전달하여 ID가 달라졌을 경우에만 취소하도록 구현 필요.
              Workmanager().cancelByTag('activity_notification');

              DateTime currentTime = DateTime.now();

              for (var schedule
                  in LmsManager().getBeforeDeadLineActivityList()) {
                DateTime deadLine = DateFormat('yyyy-MM-dd HH:mm')
                    .parse(schedule.activityDeadLine!);
                DateTime? scheduleDate;

                if (schedule.activityLeftTime == '6시간') {
                  scheduleDate = deadLine.subtract(const Duration(hours: 6));
                } else if (schedule.activityLeftTime == '1일') {
                  scheduleDate = deadLine.subtract(const Duration(days: 1));
                } else if (schedule.activityLeftTime == '3일') {
                  scheduleDate = deadLine.subtract(const Duration(days: 3));
                } else if (schedule.activityLeftTime == '5일') {
                  scheduleDate = deadLine.subtract(const Duration(days: 5));
                }

                print(
                    '마감시간: ${schedule.activityDeadLine}, ${schedule.activityLeftTime} 전: ${DateFormat('yyyy-MM-dd HH:mm').format(scheduleDate!)}');
                print(
                    '현재시간: ${DateFormat('yyyy-MM-dd HH:mm').format(currentTime)}, 앞으로 ${scheduleDate.difference(currentTime).toString()} 시간 뒤에 알림');
                print(
                    '[${schedule.courseTitle}] "${schedule.activityTitle}" 예약됨: ' +
                        DateFormat('yyyy-MM-dd HH:mm').format(currentTime
                            .add(scheduleDate.difference(currentTime))));

                Workmanager().registerOneOffTask(schedule.id!, schedule.id!,
                    tag: 'activity_notification',
                    existingWorkPolicy: ExistingWorkPolicy.replace,
                    initialDelay: scheduleDate.difference(currentTime),
                    inputData: schedule.toMap());
              }

              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                      id: 0,
                      channelKey: 'update_activities',
                      wakeUpScreen: false,
                      summary: '업데이트',
                      title: 'LMS 데이터 업데이트 완료',
                      backgroundColor: Colors.redAccent,
                      notificationLayout: NotificationLayout.Default));

              // 데이터 업데이트 Notification 제거
              // AwesomeNotifications()
              //     .dismissNotificationsByChannelKey('update_activities');
            } else {
              // 로그인 실패 Notification 표시
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                      id: 0,
                      channelKey: 'update_activities',
                      wakeUpScreen: true,
                      summary: '업데이트 실패',
                      title: 'LMS에 로그인할 수 없습니다',
                      body: '아이디와 비밀번호를 확인해주세요',
                      backgroundColor: Colors.redAccent,
                      notificationLayout: NotificationLayout.ProgressBar,
                      autoDismissible: true));
            }
          } else {
            print('자동로그인 비활성화');
          }
        }
        break;
      default:
        // Notification 아이디 구분을 위해 SharedPreferences에 마지막 ID값 불러오기 후 증가된 값 저장.
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // 저장된 데이터를 Schedule 값으로 변경.
        Schedule schedule = Schedule.fromMap(inputData!);

        // 만약 이미 제출한 과제에 대한 알림이 설정에서 활성화 되어있지 않을 경우 알림을 실행하지 않도록 break.
        if (schedule.activityState!) {
          bool? state = prefs.getBool(keyNotifyFinishedActivities);
          if (state == null || state == false) {
            break;
          }
        }

        // 만약 해당 알림의 활동(과제, 동영상)에 대해서 설정에서 활성화 되어있지 않을 경우 알림을 실행하지 않도록 break.
        if (schedule.activityType == 'assignment') {
          bool? state = prefs.getBool(keyNotifyAssignment);
          if (state == null || state == false) {
            break;
          }

          // 만약 해당 알림 종류(6시간, 1일, 3일, 5일)에 대해서 설정에서 활성화 되어있지 않을 경우 알림을 실행하지 않도록 break.
          if (schedule.activityLeftTime == '6시간') {
            bool? state = prefs.getBool(keyNotifyAssignmentBefore6Hours);
            if (state == null || state == false) {
              break;
            }
          } else if (schedule.activityLeftTime == '1일') {
            bool? state = prefs.getBool(keyNotifyAssignmentBefore1Day);
            if (state == null || state == false) {
              break;
            }
          } else if (schedule.activityLeftTime == '3일') {
            bool? state = prefs.getBool(keyNotifyAssignmentBefore3Days);
            if (state == null || state == false) {
              break;
            }
          } else if (schedule.activityLeftTime == '5일') {
            bool? state = prefs.getBool(keyNotifyAssignmentBefore5Days);
            if (state == null || state == false) {
              break;
            }
          }
        } else if (schedule.activityType == 'video') {
          bool? state = prefs.getBool(keyNotifyVideo);
          if (state == null || state == false) {
            break;
          }

          // 만약 해당 알림 종류(6시간, 1일, 3일, 5일)에 대해서 설정에서 활성화 되어있지 않을 경우 알림을 실행하지 않도록 break.
          if (schedule.activityLeftTime == '6시간') {
            bool? state = prefs.getBool(keyNotifyVideoBefore6Hours);
            if (state == null || state == false) {
              break;
            }
          } else if (schedule.activityLeftTime == '1일') {
            bool? state = prefs.getBool(keyNotifyVideoBefore1Day);
            if (state == null || state == false) {
              break;
            }
          } else if (schedule.activityLeftTime == '3일') {
            bool? state = prefs.getBool(keyNotifyVideoBefore3Days);
            if (state == null || state == false) {
              break;
            }
          } else if (schedule.activityLeftTime == '5일') {
            bool? state = prefs.getBool(keyNotifyVideoBefore5Days);
            if (state == null || state == false) {
              break;
            }
          }
        }

        int id = prefs.getInt(keyNotificationId)! + 1;
        prefs.setInt(keyNotificationId, id);

        print('[알림 실행]' + schedule.toString());
        // Notificaion 표시
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: id,
                channelKey: 'alert_lefttime',
                wakeUpScreen: true,
                autoDismissible: false,
                summary:
                    (schedule.courseTitle! + ' [' + schedule.weekTitle! + ']'),
                title: (schedule.activityType == 'assignment'
                        ? '[과제]   '
                        : '[동영상]   ') +
                    schedule.activityTitle!,
                body: '마감까지 ' +
                    schedule.activityLeftTime! +
                    ' 남았습니다! ' +
                    (schedule.activityType == 'assignment'
                        ? (schedule.activityState! ? '(제출완료)' : '(미제출)')
                        : (schedule.activityState! ? '(시청완료)' : '(미시청)')),
                backgroundColor: Colors.redAccent,
                notificationLayout: NotificationLayout.Inbox,
                category: NotificationCategory.Reminder));
        break;
    }

    return Future.value(true);
  });
}

/// LMS 리마인더 main 함수.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getBool(keyTutorialShowed) == null) {
    prefs.setBool(keyNotifyFinishedActivities, true);
    prefs.setBool(keyNotifyVideo, true);
    prefs.setBool(keyNotifyVideoBefore6Hours, true);
    prefs.setBool(keyNotifyVideoBefore1Day, true);
    prefs.setBool(keyNotifyVideoBefore3Days, true);
    prefs.setBool(keyNotifyVideoBefore5Days, true);
    prefs.setBool(keyNotifyAssignment, true);
    prefs.setBool(keyNotifyAssignmentBefore6Hours, true);
    prefs.setBool(keyNotifyAssignmentBefore1Day, true);
    prefs.setBool(keyNotifyAssignmentBefore3Days, true);
    prefs.setBool(keyNotifyAssignmentBefore5Days, true);
    prefs.setString(keyUserId, '');
    prefs.setString(keyUserPw, '');
    prefs.setBool(keyTutorialShowed, false);
    prefs.setInt(keyNotificationId, 0);
    prefs.setString(keyLastUpdateTime, '업데이트 내역 없음');
  }

  // WorkManager 초기화
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  Workmanager().registerPeriodicTask(
    'update_activities',
    'update_activities',
    existingWorkPolicy: ExistingWorkPolicy.keep,
    initialDelay: const Duration(hours: 0),
    frequency: const Duration(hours: 4),
  );

  // Awesome Notification 초기화
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'update_activities',
            channelName: 'LMS 활동 목록 업데이트',
            groupKey: 'basic_channel_group',
            channelDescription: 'LMS에서 과제와 동영상 업데이트 중 보내는 알림',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.Low),
        NotificationChannel(
            channelKey: 'alert_lefttime',
            channelName: '마감 전 알림',
            channelDescription: '과제나 동영상 마감 전 띄워주는 알림',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.High),
      ],
      debug: false);

  runApp(const AppMainStateful(
    applicationName: 'LMS 리마인더',
    appBarTitle: 'LMS 리마인더',
    showDebugLabel: false,
    primarySwatchColor: Colors.blue,
  ));
}
