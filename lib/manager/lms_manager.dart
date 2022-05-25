import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:lms_reminder/manager/dio_manager.dart';
import 'package:lms_reminder/model/assignment.dart';
import 'package:lms_reminder/model/course.dart';
import 'package:lms_reminder/model/lecture.dart';
import 'package:lms_reminder/model/schedule.dart';

import '../model/notice.dart';
import '../model/video.dart';

/// LMS에서 데이터 불러오기 및 불러온 데이터를 관리하는 클래스.
class LmsManager {
  /// Singleton Pattern 구현을 위한 객체.
  static final LmsManager _instance = LmsManager._constructor();

  /// 과목 리스트.
  List<Course> courseList = List.empty(growable: true);

  /// 데이터 로딩 상태.
  static bool isLoading = false;

  LmsManager._constructor() {
    DioManager().init(
      BaseOptions(
          baseUrl: 'https://learn.hoseo.ac.kr',
          validateStatus: (statusCode) {
            return statusCode! < 500;
          }),
    );
  }

  factory LmsManager() {
    return _instance;
  }

  /// LMS 로그인.
  Future<bool> login(String username, String password) async {
    isLoading = true;
    // 로그인 요청 전송
    Response response = await DioManager().httpPost(
        Options(
            followRedirects: false,
            contentType: 'application/x-www-form-urlencoded'),
        '/login/index.php',
        {'username': username, 'password': password});

    // Cookie 값 저장
    int moodleSessionCount = 0;
    for (var element in response.headers['set-cookie']!) {
      if (element.contains("MoodleSession")) {
        if (moodleSessionCount == 0) {
          moodleSessionCount++;
        } else if (moodleSessionCount == 1) {
          DioManager().cookie = element.substring(0, element.indexOf(";"));
          break;
        }
      }
    }

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

  /// LMS 내 강좌 목록 불러오기.
  Future getCourseList() async {
    isLoading = true;
    courseList = Course.parseCoursesFromHtml((await DioManager()
            .httpGet(options: Options(), useExistCookie: true, subUrl: ''))
        .data
        .toString());
    isLoading = false;
  }

  /// LMS 내 공지사항 불러오기.
  Future getNoticeList() async {
    isLoading = true;
    for (var course in courseList) {
      List<Notice> noticeList = await Notice.praseNoticeFromHtml(
          course,
          (await DioManager().httpGet(
                  options: Options(),
                  useExistCookie: true,
                  subUrl: course.noticeListUrl))
              .data
              .toString());

      course.noticeList = noticeList;
    }
    isLoading = false;
  }

  /// LMS 내 강의 목록 불러오기
  Future getLectureList() async {
    isLoading = true;
    for (var course in courseList) {
      course.lectureList = Lecture.parseLecturesFromHtml(
          course,
          (await DioManager().httpGet(
                  options: Options(), useExistCookie: true, subUrl: course.url))
              .data
              .toString());
    }
    isLoading = false;
  }

  /// LMS 내 과제 목록 불러오기
  Future getAssignmentList() async {
    isLoading = true;
    for (var course in courseList) {
      for (var lecture in course.lectureList) {
        for (var assignment in lecture.assignmentList) {
          await assignment.update(this);
        }
      }
    }
    isLoading = false;
  }

  /// LMS 내 동영상 강의 목록 불러오기
  Future getVideoList() async {
    isLoading = true;
    for (var course in courseList) {
      String videoListUrl = '/report/ubcompletion/user_progress_a.php?' +
          course.url.substring(course.url.indexOf('id='));

      List<List<Video>> videoGroupedByLecture = Video.parseVideosFromHtml(
          (await DioManager().httpGet(
                  options: Options(),
                  useExistCookie: true,
                  subUrl: videoListUrl))
              .data
              .toString());

      for (var lecture in course.lectureList) {
        List<Video> videos = videoGroupedByLecture
            .elementAt(course.lectureList.indexOf(lecture));

        if (videos.isEmpty) {
          lecture.videoList = List.empty(growable: true);
        } else {
          for (var video in lecture.videoList) {
            video.title =
                videos.elementAt(lecture.videoList.indexOf(video)).title;
            video.totalWatchTime = videos
                .elementAt(lecture.videoList.indexOf(video))
                .totalWatchTime;
            video.requiredWatchTime = videos
                .elementAt(lecture.videoList.indexOf(video))
                .requiredWatchTime;
            video.watch =
                videos.elementAt(lecture.videoList.indexOf(video)).watch;
          }
        }
      }
    }
    isLoading = false;
  }

  /// 미제출 과제 및 미시청 영상을 반환하는 함수.
  Future<List<dynamic>> getNotFinishedList() async {
    if (!await checkLoginState()) {}

    List<dynamic> todoList = List.empty(growable: true);

    DateTime currentTime = DateTime.now();
    for (var course in courseList) {
      for (var lecture in course.lectureList) {
        for (Assignment assignment in lecture.assignmentList) {
          if (assignment.submit == false &&
              assignment.deadLine.isAfter(currentTime)) {
            todoList.add(assignment);
          }
        }
        for (Video video in lecture.videoList) {
          if (video.watch == false && video.deadLine.isAfter(currentTime)) {
            todoList.add(video);
          }
        }
      }
    }

    todoList.sort((obj1, obj2) {
      DateTime? dateTime1;
      DateTime? dateTime2;

      if (obj1.runtimeType == Assignment) {
        dateTime1 = (obj1 as Assignment).deadLine;
      } else {
        dateTime1 = (obj1 as Video).deadLine;
      }

      if (obj2.runtimeType == Assignment) {
        dateTime2 = (obj2 as Assignment).deadLine;
      } else {
        dateTime2 = (obj2 as Video).deadLine;
      }

      return dateTime1.compareTo(dateTime2);
    });

    return todoList;
  }

  /// 제출 과제 및 시청 동영상을 반환하는 함수.
  Future<List<dynamic>> getFinishedList() async {
    if (!await checkLoginState()) {}

    List<dynamic> toDoneList = List.empty(growable: true);

    DateTime currentTime = DateTime.now();

    for (var course in courseList) {
      for (var lecture in course.lectureList) {
        for (Assignment assignment in lecture.assignmentList) {
          if (assignment.submit) {
            toDoneList.add(assignment);
          } else if (assignment.deadLine.isBefore(currentTime)) {
            toDoneList.add(assignment);
          }
        }
        for (Video video in lecture.videoList) {
          if (video.watch) {
            toDoneList.add(video);
          } else if (video.deadLine.isBefore(currentTime)) {
            toDoneList.add(video);
          }
        }
      }
    }

    toDoneList.sort((obj1, obj2) {
      String value1 = "";
      String value2 = "";

      if (obj1.runtimeType == Assignment) {
        value1 = (obj1 as Assignment).getLeftTime();
      } else {
        value1 = (obj1 as Video).getLeftTime();
      }

      if (obj2.runtimeType == Assignment) {
        value2 = (obj2 as Assignment).getLeftTime();
      } else {
        value2 = (obj2 as Video).getLeftTime();
      }

      if (value1 == '마감' && value2 == '마감') {
        int iValue1;
        int iValue2;

        if (obj1.runtimeType == Assignment) {
          iValue1 =
              int.parse((obj1 as Assignment).lecture.week.replaceAll('주차', ''));
        } else {
          iValue1 =
              int.parse((obj1 as Video).lecture.week.replaceAll('주차', ''));
        }

        if (obj2.runtimeType == Assignment) {
          iValue2 =
              int.parse((obj2 as Assignment).lecture.week.replaceAll('주차', ''));
        } else {
          iValue2 =
              int.parse((obj2 as Video).lecture.week.replaceAll('주차', ''));
        }

        return iValue2.compareTo(iValue1);
      }

      return value1.compareTo(value2);
    });

    return toDoneList;
  }

  /// 마감일이 지나지 않은 항목들을 반환하는 함수.
  List<Schedule> getBeforeDeadLineList() {
    List<Schedule> resultList = List.empty(growable: true);

    DateTime currentTime = DateTime.now();

    for (var course in courseList) {
      for (var lecture in course.lectureList) {
        for (var assignment in lecture.assignmentList) {
          if (assignment.deadLine.isAfter(currentTime.add(const Duration(hours: 6)))) {
            resultList.add(assignment.toSchedule('6시간'));
          }
          if (assignment.deadLine.isAfter(currentTime.add(const Duration(days: 1)))) {
            resultList.add(assignment.toSchedule('1일'));
          }
          if (assignment.deadLine.isAfter(currentTime.add(const Duration(days: 3)))) {
            resultList.add(assignment.toSchedule('3일'));
          }
          if (assignment.deadLine.isAfter(currentTime.add(const Duration(days: 5)))) {
            resultList.add(assignment.toSchedule('5일'));
          }
        }

        for (var video in lecture.videoList) {
          if (video.deadLine.isAfter(currentTime.add(const Duration(hours: 6)))) {
            resultList.add(video.toSchedule('6시간'));
          }
          if (video.deadLine.isAfter(currentTime.add(const Duration(days: 1)))) {
            resultList.add(video.toSchedule('1일'));
          }
          if (video.deadLine.isAfter(currentTime.add(const Duration(days: 3)))) {
            resultList.add(video.toSchedule('3일'));
          }
          if (video.deadLine.isAfter(currentTime.add(const Duration(days: 5)))) {
            resultList.add(video.toSchedule('5일'));
          }
        }
      }
    }

    return resultList;
  }

  Future<List<Notice>> getAllNoticeList() async {
    List<Notice> noticeList = List.empty(growable: true);
    for(var course in courseList) {
      noticeList.addAll(course.noticeList);
    }

    noticeList.sort((obj1, obj2) {
      DateTime value1 = DateFormat('yyyy-MM-dd').parse(obj1.date);
      DateTime value2 = DateFormat('yyyy-MM-dd').parse(obj2.date);

      return value2.compareTo(value1);
    });

    return noticeList;
  }

  /// Course, Lecture, Assignment, Video를 반환하는 함수.
  Future refreshAllData() async {
    await getCourseList();
    await getLectureList();
    await getNoticeList();
    await getAssignmentList();
    await getVideoList();
  }
}
