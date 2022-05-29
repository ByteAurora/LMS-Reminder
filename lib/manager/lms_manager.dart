import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms_reminder/manager/dio_manager.dart';
import 'package:lms_reminder/model/assignment.dart';
import 'package:lms_reminder/model/course.dart';
import 'package:lms_reminder/model/schedule.dart';
import 'package:lms_reminder/model/week.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../main.dart';
import '../model/activity.dart';
import '../model/notice.dart';
import '../model/video.dart';
import '../sharedpreferences_key.dart';

/// LMS에 로그인 및 강좌, 주차, 공지사항, 과제, 동영상 리스트를 불러오는 역할을 담당하는 Manager 클래스.
class LmsManager {
  /// Singleton Pattern 구현을 위한 객체.
  static final LmsManager _instance = LmsManager._constructor();

  factory LmsManager() {
    return _instance;
  }

  /// LmsManager 생성자.
  LmsManager._constructor() {
    DioManager().init(
      BaseOptions(
          // DioManager에서 사용할 기본 URL.
          baseUrl: 'https://learn.hoseo.ac.kr',
          // Cookie를 가져오기 위해 redirect를 false 할 경우 발생하는 Response Code 오류 방지를 위한 함수.
          validateStatus: (statusCode) {
            return statusCode! < 500;
          }),
    );
  }

  /// 데이터 로딩 상태.
  static bool isLoading = false;

  /// 강좌 리스트.
  List<Course> courseList = List.empty(growable: true);

  /// 매개변수로 전달된 username, password를 사용하여 LMS에 로그인하는 함수.
  Future<bool> login(String username, String password) async {
    isLoading = true;

    // 로그인 요청 전송.
    Response response = await DioManager().httpPost(
        Options(
            followRedirects: false,
            contentType: 'application/x-www-form-urlencoded'),

        // POST 전송 시 LMS에서는 username, password를 form 형식으로 전송.
        '/login/index.php',

        // 로그인 시 사용하는 URL.
        {'username': username, 'password': password});

    // 반환되는 MoodleSession 값 중 두 번째 값을 이용해야 LMS 로그인 가능.
    // MoodleSession 개수를 확인하기 위한 지역변수.
    int moodleSessionCount = 0;
    for (var element in response.headers['set-cookie']!) {
      if (element.contains("MoodleSession")) {
        if (moodleSessionCount == 0) {
          moodleSessionCount++;
        } else if (moodleSessionCount == 1) {
          // MoodleSession에서 추출한 cookie를 DioManager에 등록.
          DioManager().cookie = element.substring(0, element.indexOf(";"));
          break;
        }
      }
    }

    // 추출한 cookie를 이용하여 로그인 여부 확인.
    bool result = (await DioManager()
            .httpGet(options: Options(), useExistCookie: true, subUrl: ''))
        .data
        .toString()
        .contains('예정');

    isLoading = false;

    return result;
  }

  /// 로그인 상태 확인.
  Future<bool> checkLoginState() async {
    return (await DioManager()
            .httpGet(options: Options(), useExistCookie: true, subUrl: ''))
        .data
        .toString()
        .contains('예정');
  }

  /// LMS에서 강좌 리스트를 불러오는 함수.
  Future getCourseListFromLms() async {
    isLoading = true;
    courseList = Course.parseCourseListFromHtml((await DioManager()
            .httpGet(options: Options(), useExistCookie: true, subUrl: ''))
        .data
        .toString());
    isLoading = false;
  }

  /// LMS에서 강좌별 공지사항 리스트를 불러오는 함수. 공지사항은 각각에 해당하는 강좌 객체 안에 리스트로 저장.
  Future getNoticeListFromLms() async {
    isLoading = true;
    for (var course in courseList) {
      List<Notice> noticeList = await Notice.praseNoticeListFromHtml(
          course,
          (await DioManager().httpGet(
                  options: Options(),
                  useExistCookie: true,
                  subUrl: course.noticeListUrl))
              .data
              .toString());

      // 불러온 공지사항을 해당 강좌 객체 안에 리스트로 저장.
      course.noticeList = noticeList;
    }
    isLoading = false;
  }

  /// LMS에서 주차 리스트를 불러오는 함수. 주차는 각가에 해당하는 강좌 객체 안에 리스트로 저장.
  Future getWeekListFromLms() async {
    isLoading = true;
    for (var course in courseList) {
      course.weekList = Week.parseWeekListFromHtml(
          course,
          (await DioManager().httpGet(
                  options: Options(), useExistCookie: true, subUrl: course.url))
              .data
              .toString());
    }
    isLoading = false;
  }

  /// LMS에서 각 주차에 속하는 과제들을 불러오는 함수. 과제는 각 주차 객체 안에 리스트로 저장.
  Future getAssignmentListFromLms() async {
    isLoading = true;
    for (var course in courseList) {
      for (var week in course.weekList) {
        for (var assignment in week.assignmentList) {
          await assignment.update(this);
        }
      }
    }
    isLoading = false;
  }

  /// LMS에서 각 주차에 속하는 동영상들을 불러오는 함수. 동영상은 각 주차 객체 안에 리스트로 저장.
  Future getVideoListFromLms() async {
    isLoading = true;
    for (var course in courseList) {
      // 강좌 객체에 저장된 id 값을 이용하여 해당 강좌의 온라인 출석부 링크로 변환.
      String videoListUrl = '/report/ubcompletion/user_progress_a.php?' +
          course.url.substring(course.url.indexOf('id='));

      // 동영상을 주차별로 그룹화한 리스트.
      List<List<Video>> videoGroupByWeek = Video.parseVideoListFromHtml(
          (await DioManager().httpGet(
                  options: Options(),
                  useExistCookie: true,
                  subUrl: videoListUrl))
              .data
              .toString());

      for (var week in course.weekList) {
        // 한 주차에 속한 동영상 리스트.
        List<Video> videos =
            videoGroupByWeek.elementAt(course.weekList.indexOf(week));

        // 아래 if문 과정을 거치면 출석부 영상에 있는 영상 즉, 출석과 관련된 영상만 리스트에 추가되며 출석과 관련이 없는 영상은 리스트에 추가되지 않음.
        if (videos.isEmpty) {
          // 해당 주차에 속한 동영상 리스트이 없을 경우 해당 주차의 동영상 리스트를 빈 리스트로 설정.
          week.videoList = List.empty(growable: true);
        } else {
          List<Video> attendanceVideos = List.empty(growable: true);
          List<Video> tempVideos = List.from(videos);

          for (var video in week.videoList) {
            for (var checkVideo in tempVideos) {
              if (video.title == checkVideo.title) {
                attendanceVideos.add(video);
                tempVideos.remove(checkVideo);
                break;
              }
            }
          }

          // 해당 주차에 속한 동영상 리스트이 있을 경우
          for (var video in attendanceVideos) {
            // 주차에 미리 저장되어있던 video 객체에 온라인 출석부에서 가져온 Video 값 대입.
            video.title =
                videos.elementAt(attendanceVideos.indexOf(video)).title;
            video.totalWatchTime = videos
                .elementAt(attendanceVideos.indexOf(video))
                .totalWatchTime;
            video.requiredWatchTime = videos
                .elementAt(attendanceVideos.indexOf(video))
                .requiredWatchTime;
            video.done = videos.elementAt(attendanceVideos.indexOf(video)).done;
          }

          week.videoList = attendanceVideos;
        }
      }
    }
    isLoading = false;
  }

  /// 미제출 과제 및 미시청 동영상을 반환하는 함수. (미제출, 미시청한 활동이더라도 마감일이 자난 활동은 반환하지 않음)
  Future<List<dynamic>> getNotFinishedActivityList() async {
    if (!await checkLoginState()) {}

    // 미제출 과제 및 미시청 동영상 리스트.
    List<dynamic> notFinishedActivityList = List.empty(growable: true);

    // 해당 활동(과제, 동영상)이 마감된 활동인지 확인을 위해 현재 시간을 가지고 있는 지역변수.
    DateTime currentTime = DateTime.now();

    for (var course in courseList) {
      for (var week in course.weekList) {
        for (Assignment assignment in week.assignmentList) {
          if (assignment.done == false &&
              assignment.deadLine.isAfter(currentTime)) {
            // 해당 과제를 제출하지 않았고 마감일이 지나지 않은 과제일 경우.
            notFinishedActivityList.add(assignment);
          }
        }
        for (Video video in week.videoList) {
          if (video.done == false && video.deadLine.isAfter(currentTime)) {
            // 해당 동영상을 시청하지 않았고 마감일이 지나지 않은 동영상일 경우.
            notFinishedActivityList.add(video);
          }
        }
      }
    }

    // 활동들을 현재로부터 마감일까지 남은 시간을 비교하여 정렬해주는 부분.
    notFinishedActivityList.sort((activity1, activity2) {
      return activity1.deadLine.compareTo(activity2.deadLine);
    });

    return notFinishedActivityList;
  }

  /// 제출 과제 및 시청 동영상을 반환하는 함수. (미제출, 미시청한 활동이라도 마감일이 지났을 경우 함께 반환)
  Future<List<dynamic>> getFinishedActivityList() async {
    if (!await checkLoginState()) {}
    
    // 제출된 과제 및 시청한 동영상 리스트.
    List<dynamic> finishedActivityList = List.empty(growable: true);

    // 해당 활동(과제, 동영상)이 마감된 활동인지 확인을 위해 현재 시간을 가지고 있는 지역변수.
    DateTime currentTime = DateTime.now();

    for (var course in courseList) {
      for (var week in course.weekList) {
        for (Assignment assignment in week.assignmentList) {
          if (assignment.done) {
            finishedActivityList.add(assignment);
          } else if (assignment.deadLine.isBefore(currentTime)) {
            finishedActivityList.add(assignment);
          }
        }
        for (Video video in week.videoList) {
          if (video.done) {
            finishedActivityList.add(video);
          } else if (video.deadLine.isBefore(currentTime)) {
            finishedActivityList.add(video);
          }
        }
      }
    }
    
    // 활동들을 현재로부터 마감일까지 남은 시간을 비교하여 정렬해주는 부분. 이미 마감된 활동들은 주차를 기준으로 정렬.
    finishedActivityList.sort((activity1, activity2) {
      String activity1LeftTime = (activity1 as Activity).getLeftTime();
      String activity2LeftTime = (activity2 as Activity).getLeftTime();

      if (activity1LeftTime == '마감' && activity2LeftTime == '마감') {
        return int.parse((activity2).week.title.replaceAll('주차', ''))
            .compareTo(int.parse((activity1).week.title.replaceAll('주차', '')));
      }

      if (activity1LeftTime.contains('D-') && activity2LeftTime.contains('D-')) {
        return int.parse(activity1LeftTime.replaceAll('D-', ''))
            .compareTo(int.parse(activity2LeftTime.replaceAll('D-', '')));
      }

      return activity1LeftTime.compareTo(activity2LeftTime);
    });

    return finishedActivityList;
  }

  /// 마감일이 지나지 않은 항목들을 반환하는 함수. (알림 설정이 필요한 활동 리스트이 필요할 때 사용)
  Future<List<Schedule>> getBeforeDeadLineActivityList() async {
    List<Schedule> beforeDeadLineActivityList = List.empty(growable: true);

    DateTime currentTime = DateTime.now();

    for (var course in courseList) {
      for (var week in course.weekList) {
        for (var assignment in week.assignmentList) {
          if (assignment.deadLine
              .isAfter(currentTime.add(const Duration(hours: 6)))) {
            beforeDeadLineActivityList.add(await assignment.toSchedule('6시간'));
          }
          if (assignment.deadLine
              .isAfter(currentTime.add(const Duration(days: 1)))) {
            beforeDeadLineActivityList.add(await assignment.toSchedule('1일'));
          }
          if (assignment.deadLine
              .isAfter(currentTime.add(const Duration(days: 3)))) {
            beforeDeadLineActivityList.add(await assignment.toSchedule('3일'));
          }
          if (assignment.deadLine
              .isAfter(currentTime.add(const Duration(days: 5)))) {
            beforeDeadLineActivityList.add(await assignment.toSchedule('5일'));
          }
        }

        for (var video in week.videoList) {
          if (video.deadLine
              .isAfter(currentTime.add(const Duration(hours: 6)))) {
            beforeDeadLineActivityList.add(await video.toSchedule('6시간'));
          }
          if (video.deadLine
              .isAfter(currentTime.add(const Duration(days: 1)))) {
            beforeDeadLineActivityList.add(await video.toSchedule('1일'));
          }
          if (video.deadLine
              .isAfter(currentTime.add(const Duration(days: 3)))) {
            beforeDeadLineActivityList.add(await video.toSchedule('3일'));
          }
          if (video.deadLine
              .isAfter(currentTime.add(const Duration(days: 5)))) {
            beforeDeadLineActivityList.add(await video.toSchedule('5일'));
          }
        }
      }
    }

    return beforeDeadLineActivityList;
  }

  /// LMS에서 불러왔던 강좌별 공지들을 하나의 리스트로 만들어 반환해주는 함수.
  Future<List<Notice>> getNoticeList() async {
    // 모든 강좌별 공지들을 하나로 모은 리스트.
    List<Notice> noticeList = List.empty(growable: true);
    for (var course in courseList) {
      noticeList.addAll(course.noticeList);
    }

    // 리스트에 포함된 공지사항들을 날짜순으로 정렬하는 부분.
    noticeList.sort((notice1, notice2) {
      DateTime notice1Date = DateFormat('yyyy-MM-dd').parse(notice1.date);
      DateTime notice2Date = DateFormat('yyyy-MM-dd').parse(notice2.date);

      return notice2Date.compareTo(notice1Date);
    });

    return noticeList;
  }

  /// 모든 강좌, 주차, 공지사항, 과제, 동영상 데이터를 LMS로부터 업데이트하는 함수.
  Future reloadAllDataFromLms() async {
    await getCourseListFromLms();
    print('Course loaded');
    await getWeekListFromLms();
    print('Week loaded');
    await getNoticeListFromLms();
    print('Notice loaded');
    await getAssignmentListFromLms();
    print('Assignment loaded');
    await getVideoListFromLms();
    print('Video loaded');
    updateSchedule();
  }

  Future updateSchedule() async {
    // 활동 목록 업데이트 작업일 경우.
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(keyLastUpdateTime,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));

    // 이전에 설정된 모든 알림 제거 - 사용자가 바뀌었을 경우도 있기 때문에 WorkManager의 replace만으로는 해결 불가.
    // 추후 WorkManager에 사용자 ID값도 전달하여 ID가 달라졌을 경우에만 취소하도록 구현 필요.
    Workmanager().cancelByTag('activity_notification');

    DateTime currentTime = DateTime.now();

    for (var schedule in await LmsManager().getBeforeDeadLineActivityList()) {
      DateTime deadLine =
          DateFormat('yyyy-MM-dd HH:mm').parse(schedule.activityDeadLine!);
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

      Workmanager().registerOneOffTask(schedule.id!, schedule.id!,
          tag: 'activity_notification',
          existingWorkPolicy: ExistingWorkPolicy.replace,
          initialDelay: scheduleDate!.difference(currentTime),
          inputData: schedule.toMap());

      print(
          '마감시간: ${schedule.activityDeadLine}, ${schedule.activityLeftTime} 전: ${DateFormat('yyyy-MM-dd HH:mm').format(scheduleDate)}');
      print(
          '현재시간: ${DateFormat('yyyy-MM-dd HH:mm').format(currentTime)}, 앞으로 ${scheduleDate.difference(currentTime).toString()} 시간 뒤에 알림');
      print('[${schedule.courseTitle}] "${schedule.activityTitle}" 예약됨: ' +
          DateFormat('yyyy-MM-dd HH:mm')
              .format(currentTime.add(scheduleDate.difference(currentTime))));
    }

    Workmanager().registerPeriodicTask(
      'update_activities',
      'update_activities',
      existingWorkPolicy: ExistingWorkPolicy.replace,
      initialDelay: const Duration(hours: 0),
      frequency: const Duration(minutes: 15),
    );
  }
}
