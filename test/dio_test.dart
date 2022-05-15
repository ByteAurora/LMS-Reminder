import 'package:lms_reminder/manager/lms_manager.dart';

Future<void> main() async {
  var stopWatch = Stopwatch();

  stopWatch.start();
  print(await LmsManager().login('20181179', 'dudwls1234'));
  print('로그인: ' + stopWatch.elapsed.inMilliseconds.toString() + "ms");

  stopWatch.reset();
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

  for (var course in LmsManager().courseList) {
    print(
        '[과목] ${course.title}[${course.classNumber}] (교수: ${course.professor})');
    for (var lecture in course.lectureList) {
      print('   [주차] ${lecture.week}(${lecture.date})');
      for (var assignment in lecture.assignmentList) {
        print('       [과제] ${assignment.title}');
        print('             - ${assignment.submit ? '제출완료' : '미제출'}');
        print('             - ${assignment.deadLine.toString()}');
        print('             - ${assignment.grade}');
        print('             - ${assignment.content}');
        print('             - ${assignment.leftTime}');
      }
      for (var video in lecture.videoList) {
        print('       [영상] ${video.title}');
        print('             - ${video.watch ? '출석' : '결석'}');
        print('             - ${video.enableTime.toString()}');
        print('             - ${video.deadLine.toString()}');
        print('             - ${video.requiredWatchTime}');
        print('             - ${video.totalWatchTime}');
      }
    }
  }
}
