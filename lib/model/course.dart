import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;

import 'lecture.dart';

/// 강좌 정보를 관리하는 클래스.
class Course {
  /// 강좌명.
  String? _title;

  /// 담당교수.
  String? _professor;

  /// 분반.
  String? _classNumber;

  /// 강좌 URL.
  String? _url;

  /// 해당 강좌의 주차별 강의 목록.
  List? _lectureList;

  /// 전달된 html에서 강좌 정보를 추출하여 반환하는 함수.
  static List<Course> parseCoursesFromHtml(String html) {
    List<Course> courseList = List.empty(growable: true);

    html_dom.Document document = html_parser.parse(html);

    document.getElementsByClassName('course_label_re_02').forEach((element) {
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

      // 강좌 내 주차별 강의 목록 리스트 생성 필요
      Lecture.parseLecturesFromHtml('html');

      courseList.add(course);
    });

    return courseList;
  }

  String get url => _url!;

  set url(String value) {
    _url = value;
  }

  String get classNumber => _classNumber!;

  set classNumber(String value) {
    _classNumber = value;
  }

  String get professor => _professor!;

  set professor(String value) {
    _professor = value;
  }

  String get title => _title!;

  set title(String value) {
    _title = value;
  }

  List get lectureList => _lectureList!;

  set lectureList(List value) {
    _lectureList = value;
  }
}
