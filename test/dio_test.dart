import 'package:lms_reminder/manager/lms_manager.dart';

Future<void> main() async {
  LmsManager lmsManager = LmsManager();

  print(await lmsManager.login('20181179', 'dudwls1234'));

  await lmsManager.getCourseList();

  await lmsManager.getLectureList();

  for (var element in (lmsManager.courseList)) {
    print(element.title +
        "/" +
        element.classNumber +
        "/" +
        element.professor +
        "/" +
        element.url + "\n" + element.lectureList.toString());
  }
}
