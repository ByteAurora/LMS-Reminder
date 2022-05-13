import 'package:lms_reminder/manager/lms_manager.dart';

Future<void> main() async {
  LmsManager lmsManager = LmsManager();

  print(await lmsManager.login('20181179', 'dudwls1234'));

  await lmsManager.getCourseList();

  await lmsManager.getLectureList();

  await lmsManager.getAssignmentList();

  for (var course in lmsManager.courseList) {
    print(
        '[과목] ${course.title}[${course.classNumber}] (교수: ${course.professor})');
    for (var lecture in course.lectureList) {
      print('   [주차] ${lecture.week}(${lecture.date})');
      for (var assignment in lecture.assignmentList) {
        print('       [과제] ${assignment.title}');
        print('             - ${assignment.submitState ? '제출완료' : '미제출'}');
        print('             - ${assignment.content}');
        print('             - ${assignment.leftTime}');
      }
    }
  }
}
