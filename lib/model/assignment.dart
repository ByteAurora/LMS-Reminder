import 'package:dio/dio.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:lms_reminder/manager/lms_manager.dart';

import '../manager/dio_manager.dart';
import 'activity.dart';
import 'week.dart';

/// 과제 정보를 관리하는 클래스.
class Assignment extends Activity {
  /// 과제 URL.
  String? _url;

  /// 과제 설명 및 내용.
  String? _content;

  /// 채점 상태
  String? _grade;

  /// 남은 기한.
  String? _leftTime;

  /// URL로부터 과제 정보 갱신.
  Future update(LmsManager lmsManager) async {
    html_dom.Document document = html_parser.parse((await DioManager()
            .httpGet(options: Options(), useExistCookie: true, subUrl: url))
        .data
        .toString());

    title = document
        .getElementById('region-main')!
        .getElementsByTagName('h2')[0]
        .text
        .trim();

    document
        .getElementById('region-main')!
        .getElementsByTagName('div')
        .forEach((element) {
      if (element.className == 'box generalbox boxaligncenter') {
        content = element.innerHtml
            .trim()
            .replaceAll('<br>', '')
            .replaceAll('<p></p>', '');
      } else if (element.className == 'submissionstatustable') {
        element
            .getElementsByClassName(
                'box boxaligncenter submissionsummarytable')[0]
            .getElementsByTagName('table')[0]
            .getElementsByTagName('tbody')[0]
            .getElementsByTagName('tr')
            .forEach((element2) {
          String text = element2.getElementsByTagName('td')[0].text;

          if (text.contains("제출 여부")) {
            done = (element2.text.contains("제출 완료"));
          } else if (text.contains("종료 일시")) {
            deadLine = DateFormat('yyyy-MM-dd HH:mm:ss')
                .parse(element2.text.replaceAll("종료 일시", "").trim() + ":00");
          } else if (text.contains("마감까지 남은 기한")) {
            leftTime = element2.text.replaceAll("마감까지 남은 기한", "").trim();
          } else if (text.contains('채점 상황')) {
            grade = element2.text.replaceAll("채점 상황", "").trim();
          }
        });
      }
    });
  }

  /// Assignment 생성자.
  Assignment(Week week) : super('assignment') {
    this.week = week;
  }

  String get content => _content!;

  set content(String value) {
    _content = value;
  }

  String get leftTime => _leftTime!;

  set leftTime(String value) {
    _leftTime = value;
  }

  String get url => _url!;

  set url(String value) {
    _url = value;
  }

  String get grade => _grade!;

  set grade(String value) {
    _grade = value;
  }
}
