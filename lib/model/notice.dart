import 'package:dio/dio.dart';

import '../manager/dio_manager.dart';
import 'course.dart';

import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;

/// 공지사항 정보를 관리하는 클래스.
class Notice {
  /// 과목.
  Course? _course;

  /// 공지사항 url.
  String? _url;

  /// 제목.
  String? _title;

  /// 내용.
  String? _content;

  /// 작성자.
  String? _author;

  /// 날짜.
  String? _date;

  /// 전달된 html에서 영상 정보를 추출하여 반환하는 함수.
  static Future<List<Notice>> praseNoticeFromHtml(
      Course course, String html) async {
    List<Notice> courseNoticeList = List.empty(growable: true);

    html_dom.Document document = html_parser.parse(html);

    document
        .getElementById('ubboard_list_form')!
        .getElementsByTagName('table')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr')
        .forEach((noticeElement) async {
      Notice notice = Notice(course);

      String temp = noticeElement.getElementsByTagName('td')[1].innerHtml;
      notice.url = temp.substring(temp.indexOf('kr') + 2, temp.indexOf('">')).replaceAll('&amp;', '&');
      notice.title = noticeElement.getElementsByTagName('td')[1].text.trim();
      notice.author = noticeElement.getElementsByTagName('td')[2].text.trim();
      notice.date = noticeElement.getElementsByTagName('td')[3].text.trim();
      Response response = await DioManager().httpGet(
          options: Options(), useExistCookie: true, subUrl: notice.url);
      html_dom.Document detailDocument =
          html_parser.parse(response.data.toString());

      notice.content = detailDocument
          .getElementById('region-main')!
          .getElementsByTagName('div')[0]
          .getElementsByClassName('ubboard')[0]
          .getElementsByTagName('div')[1]
          .getElementsByClassName('content')[0]
          .text;

      courseNoticeList.add(notice);
    });

    return courseNoticeList;
  }



  /// Notice 생성자.
  Notice(Course? course) {
    _course = course;
  }

  Future update() async {}

  String get title => _title!;

  set title(String value) {
    _title = value;
  }

  String get content => _content!;

  String get date => _date!;

  set date(String value) {
    _date = value;
  }

  String get author => _author!;

  set author(String value) {
    _author = value;
  }

  set content(String value) {
    _content = value;
  }

  String get url => _url!;

  set url(String value) {
    _url = value;
  }

  Course get course => _course!;

  set course(Course value) {
    _course = value;
  }
}
