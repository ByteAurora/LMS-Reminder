import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:lms_reminder/manager/lms_manager.dart';
import 'package:lms_reminder/model/schedule.dart';

import '../manager/dio_manager.dart';
import 'week.dart';

/// 과제 정보를 관리하는 클래스.
class Assignment {
  /// 주차.
  Week? _week;

  /// 과제 URL.
  String? _url;

  /// 제목.
  String? _title;

  /// 과제 설명 및 내용.
  String? _content;

  /// 제출 상태.
  bool? _submit;

  /// 채점 상태
  String? _grade;

  /// 마감일.
  DateTime? _deadLine;

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
        content = element.innerHtml.trim().replaceAll('<br>', '').replaceAll('<p></p>', '');
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
            submit = (element2.text.contains("제출 완료"));
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
  Assignment(Week week) {
    _week = week;
  }

  /// 과제 마감까지 남은 시간을 반환하는 함수.
  String getLeftTime() {
    DateTime currentTime = DateTime.now();
    if (deadLine.isBefore(currentTime)) {
      return '마감';
    }

    String result = "";
    Duration leftTime = deadLine.difference(currentTime);

    if (leftTime.inMinutes < 1440) {
      String hour = (leftTime.inMinutes ~/ 60).toString().length == 1
          ? '0' + (leftTime.inMinutes ~/ 60).toString()
          : (leftTime.inMinutes ~/ 60).toString();
      String minute = (leftTime.inMinutes % 60).toInt().toString().length == 1
          ? '0' + (leftTime.inMinutes % 60).toString()
          : (leftTime.inMinutes % 60).toString();
      return hour + ":" + minute;
    }

    result = leftTime.inDays.toString();

    return 'D-' + result;
  }

  String get title => _title!;

  set title(String value) {
    _title = value;
  }

  String get content => _content!;

  set content(String value) {
    _content = value;
  }

  bool get submit => _submit!;

  String get leftTime => _leftTime!;

  set leftTime(String value) {
    _leftTime = value;
  }

  DateTime get deadLine => _deadLine!;

  set deadLine(DateTime value) {
    _deadLine = value;
  }

  set submit(bool value) {
    _submit = value;
  }

  Week get week => _week!;

  set week(Week value) {
    _week = value;
  }

  String get url => _url!;

  set url(String value) {
    _url = value;
  }

  String get grade => _grade!;

  set grade(String value) {
    _grade = value;
  }

  Schedule toSchedule(String leftTime) {
    return Schedule(
        sha256.convert(utf8.encode(title + leftTime)).toString(),
        'assignment',
        week.weekTitle,
        week.course.title,
        title,
        DateFormat('yyyy-MM-dd HH:mm').format(deadLine),
        leftTime,
        submit);
  }
}
