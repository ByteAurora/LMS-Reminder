import 'package:lms_reminder/manager/lms_manager.dart';

Future<void> main() async {
  LmsManager lmsManager = LmsManager();

  var stopWatch = Stopwatch();

  stopWatch.start();
  print(await lmsManager.login('학번', '비밀번호'));
  print('로그인: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

  stopWatch.reset();
  stopWatch.start();
  await lmsManager.getCourseList();
  print('강좌 불러오기: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

  stopWatch.reset();
  stopWatch.start();
  await lmsManager.getLectureList();
  print('강의 불러오기: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

  stopWatch.reset();
  stopWatch.start();
  await lmsManager.getAssignmentList();
  print('과제 불러오기: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

  stopWatch.reset();
  stopWatch.start();
  await lmsManager.getVideoList();
  print('영상 불러오기: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

  for (var course in lmsManager.courseList) {
    print(
        '[과목] ${course.title}[${course.classNumber}] (교수: ${course.professor})');
    for (var lecture in course.lectureList) {
      print('   [주차] ${lecture.week}(${lecture.date})');
      for (var assignment in lecture.assignmentList) {
        print('       [과제] ${assignment.title}');
        print('             - ${assignment.submitState ? '제출완료' : '미제출'}');
        print('             - ${assignment.gradeState}');
        print('             - ${assignment.content}');
        print('             - ${assignment.leftTime}');
      }
      for (var video in lecture.videoList) {
        print('       [영상] ${video.title}');
        print('             - ${video.watchState ? '출석' : '결석'}');
        print('             - ${video.requiredWatchTime}');
        print('             - ${video.totalWatchTime}');
      }
    }
  }
}
