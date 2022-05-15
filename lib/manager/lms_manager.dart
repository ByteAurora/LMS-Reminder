import 'package:dio/dio.dart';
import 'package:lms_reminder/manager/dio_manager.dart';
import 'package:lms_reminder/model/assignment.dart';
import 'package:lms_reminder/model/course.dart';
import 'package:lms_reminder/model/lecture.dart';

import '../model/video.dart';

class LmsManager {
  static final LmsManager _instance = LmsManager._constructor();
  List<Course> courseList = List.empty(growable: true);

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

    return (await DioManager()
            .httpGet(options: Options(), useExistCookie: true, subUrl: ''))
        .data
        .toString()
        .contains('예정');
  }

  /// LMS 내 강좌 목록 불러오기.
  Future getCourseList() async {
    courseList = Course.parseCoursesFromHtml((await DioManager()
            .httpGet(options: Options(), useExistCookie: true, subUrl: ''))
        .data
        .toString());
  }

  /// LMS 내 강의 목록 불러오기
  Future getLectureList() async {
    for (var course in courseList) {
      course.lectureList = Lecture.parseLecturesFromHtml((await DioManager()
              .httpGet(
                  options: Options(), useExistCookie: true, subUrl: course.url))
          .data
          .toString());
    }
  }

  /// LMS 내 과제 목록 불러오기
  Future getAssignmentList() async {
    for (var course in courseList) {
      for (var lecture in course.lectureList) {
        for (var assignment in lecture.assignmentList) {
          await assignment.update(this);
        }
      }
    }
  }

  /// LMS 내 동영상 강의 목록 불러오기
  Future getVideoList() async {
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
  }

  Future<List<dynamic>> getNotFinishedList() async {
    List<dynamic> todoList = List.empty(growable: true);

    var stopWatch = Stopwatch();

    stopWatch.start();
    await LmsManager().getCourseList();
    print('강좌 불러오기: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

    stopWatch.reset();
    stopWatch.start();
    await LmsManager().getLectureList();
    print('강의 불러오기: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

    stopWatch.reset();
    stopWatch.start();
    await LmsManager().getAssignmentList();
    print('과제 불러오기: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

    stopWatch.reset();
    stopWatch.start();
    await LmsManager().getVideoList();
    print('영상 불러오기: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

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

    for (var element in todoList) {
      if (element.runtimeType == Assignment) {
        print((element as Assignment).title);
      } else if (element.runtimeType == Video) {
        print((element as Video).title);
      }
    }

    return todoList;
  }

  Future<List<dynamic>> getFinishedList() async {
    List<dynamic> todoList = List.empty(growable: true);

    var stopWatch = Stopwatch();

    stopWatch.start();
    await LmsManager().getCourseList();
    print('강좌 불러오기: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

    stopWatch.reset();
    stopWatch.start();
    await LmsManager().getLectureList();
    print('강의 불러오기: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

    stopWatch.reset();
    stopWatch.start();
    await LmsManager().getAssignmentList();
    print('과제 불러오기: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

    stopWatch.reset();
    stopWatch.start();
    await LmsManager().getVideoList();
    print('영상 불러오기: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

    DateTime currentTime = DateTime.now();
    for (var course in courseList) {
      for (var lecture in course.lectureList) {
        for (Assignment assignment in lecture.assignmentList) {
          if (assignment.submit == true &&
              assignment.deadLine.isAfter(currentTime)) {
            todoList.add(assignment);
          }
        }
        for (Video video in lecture.videoList) {
          if (video.watch == true && video.deadLine.isAfter(currentTime)) {
            todoList.add(video);
          }
        }
      }
    }

    for (var element in todoList) {
      if (element.runtimeType == Assignment) {
        print((element as Assignment).title);
      } else if (element.runtimeType == Video) {
        print((element as Video).title);
      }
    }

    return todoList;
  }
}
