import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;

import 'notice.dart';
import 'week.dart';

/// 강좌 클래스.
class Course {
  /// 강좌명.
  String? _title;

  /// 담당교수.
  String? _professor;

  /// 분반.
  String? _classNumber;

  /// 해당 강좌의 세부정보 URL.
  String? _url;

  /// 해당 강좌의 공지사항 목록 URL.
  String? _noticeListUrl;

  /// 해당 강좌의 주차 목록.
  List<Week>? _weekList;

  /// 해당 강좌의 공지사항 목록.
  List<Notice>? _noticeList;

  /// 전달된 html에서 강좌 목록을 추출하여 반환하는 함수.
  static List<Course> parseCourseListFromHtml(String html) {
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

  List<Week> get weekList => _weekList!;

  set weekList(List<Week> value) {
    _weekList = value;
  }

  List<Notice> get noticeList => _noticeList!;

  set noticeList(List<Notice> value) {
    _noticeList = value;
  }

  String get noticeListUrl => _noticeListUrl!;

  set noticeListUrl(String value) {
    _noticeListUrl = value;
  }
}
