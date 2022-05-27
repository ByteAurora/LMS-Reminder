import 'package:dio/dio.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:lms_reminder/manager/dio_manager.dart';
import 'package:lms_reminder/manager/lms_manager.dart';

Future<void> main() async {
  await LmsManager().login('학번', '비밀번호');
  // await LmsManager().refreshAllData();

  // for (var course in LmsManager().courseList) {
  //   for (var notice in course.noticeList) {
  //     print(course.title + "/" + notice.title);
  //   }
  // }
  html_dom.Document document = html_parser.parse((await DioManager().httpGet(
          options: Options(),
          useExistCookie: true,
          subUrl: '/course/view.php?id=10375'))
      .data
      .toString());

  String temp = document
      .getElementById('section-0')!
      .getElementsByClassName('content')[0]
      .getElementsByClassName('section img-text')[0]
      .getElementsByClassName('activity ubboard modtype_ubboard')[0]
      .getElementsByTagName('div')[4]
      .innerHtml;

  print(temp.substring(
      temp.indexOf('href="https://learn.hoseo.ac.kr') +
          'href="https://learn.hoseo.ac.kr'.length,
      temp.indexOf('">')));
}
