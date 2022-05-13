import 'package:dio/dio.dart';
import 'package:lms_reminder/manager/dio_manager.dart';
import 'package:lms_reminder/model/course.dart';
import 'package:lms_reminder/model/lecture.dart';

class LmsManager {
  DioManager? dioManager;
  List<Course> courseList = List.empty(growable: true);

  LmsManager() {
    dioManager = DioManager();
    dioManager!.init(
      BaseOptions(
          baseUrl: 'https://learn.hoseo.ac.kr',
          validateStatus: (statusCode) {
            return statusCode! < 500;
          }),
    );
  }

  /// LMS 로그인.
  Future<bool> login(String username, String password) async {
    // 로그인 요청 전송
    Response response = await dioManager!.httpPost(
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
          dioManager!.cookie = element.substring(0, element.indexOf(";"));
          break;
        }
      }
    }

    return (await dioManager!
            .httpGet(Options(headers: {'cookie': dioManager!.cookie}), ''))
        .data
        .toString()
        .contains('예정');
  }

  /// LMS 내 강좌 목록 불러오기.
  Future getCourseList() async {
    courseList = Course.parseCoursesFromHtml((await dioManager!
            .httpGet(Options(headers: {'cookie': dioManager!.cookie}), ''))
        .data
        .toString());
  }

  Future getLectureList() async {
    for (var course in courseList) {
      course.lectureList = Lecture.parseLecturesFromHtml((await dioManager!
              .httpGet(
                  Options(headers: {'cookie': dioManager!.cookie}), course.url))
          .data
          .toString());
    }
  }

  Future getAssignmentList() async {
    for (var course in courseList) {
      for (var lecture in course.lectureList) {
        for (var assignment in lecture.assignmentList) {
          await assignment.update(this);
        }
      }
    }
  }
}
