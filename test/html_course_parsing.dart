import 'dart:core';
import 'dart:io';

import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:lms_reminder/model/course.dart';

/// Html에서 Course 관련 정보 파싱 테스트.
Future<void> main() async {
  // 테스트할 강의목록 영역 html 경로
  String filePath =
      'D:\\lms_reminder\\others\\LMS page html sample\\LMS 메인화면 - full html code.html';

  String htmlContents = await File(filePath).readAsString();

  html_dom.Document document = html_parser.parse(htmlContents);
  document
      .getElementById('region-main')!
      .getElementsByTagName('div')[0]
      .getElementsByClassName('progress_courses')[0]
      .getElementsByClassName('course_lists')[0]
      .getElementsByClassName('my-course-lists coursemos-layout-0')[0]
      .getElementsByClassName('course_label_re_02')
      .forEach((element) {

    Course course = Course();

    // 강좌 URL 추출
    course.url = element.innerHtml.substring(
        element.innerHtml.indexOf('<a href="') + '<a href="'.length,
        element.innerHtml.indexOf('class="course_link"') - 2);

    // 강좌 정보 추출
    List<html_dom.Element> courseInfo =
        element.getElementsByClassName('course-title');
    String titleAndClass = courseInfo[0].getElementsByTagName('h3')[0].text;
    course.title = titleAndClass.substring(0, titleAndClass.indexOf('['));
    course.classNumber = titleAndClass.substring(
        titleAndClass.indexOf('[') + 1, titleAndClass.indexOf(']'));
    course.professor = courseInfo[0].getElementsByTagName('p')[0].text;

    print(course.title +
        " / " +
        course.classNumber +
        " / " +
        course.professor +
        " / " +
        course.url);
  });
}
