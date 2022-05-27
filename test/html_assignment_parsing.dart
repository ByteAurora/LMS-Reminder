import 'dart:core';
import 'dart:io';

import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:lms_reminder/model/assignment.dart';
import 'package:lms_reminder/model/course.dart';
import 'package:lms_reminder/model/week.dart';

/// Html에서 Assignment 관련 정보 파싱 테스트.
Future<void> main() async {
  // 테스트할 과제목록 html 경로
  String filePath =
      'D:\\lms_reminder\\others\\LMS page html sample\\LMS 과제정보 - full html code.html';

  String htmlContents = await File(filePath).readAsString();

  html_dom.Document document = html_parser.parse(htmlContents);

  Assignment assignment = Assignment(Week(Course()));

  assignment.title = document
      .getElementById('region-main')!
      .getElementsByTagName('h2')[0]
      .text;

  document
      .getElementById('region-main')!
      .getElementsByTagName('div')
      .forEach((element) {
    if (element.className == 'box generalbox boxaligncenter') {
      assignment.content = element.text;
    } else if (element.className == 'submissionstatustable') {
      element
          .getElementsByTagName('div')[0]
          .getElementsByTagName('table')[0]
          .getElementsByTagName('tbody')[0]
          .getElementsByTagName('tr')
          .forEach((element2) {
        if (element2.getElementsByTagName('td')[0].text.contains("제출 여부")) {
          assignment.done = (element2.text.contains("제출 완료"));
        } else if (element2
            .getElementsByTagName('td')[0]
            .text
            .contains("종료 일시")) {
          assignment.deadLine = DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse(element2.text.replaceAll("종료 일시", "").trim() + ":00");
        } else if (element2
            .getElementsByTagName('td')[0]
            .text
            .contains("마감까지 남은 기한")) {
          assignment.leftTime =
              element2.text.replaceAll("마감까지 남은 기한", "").trim();
        }
      });
    }
  });

  print(assignment.title +
      "/" +
      assignment.content +
      "/" +
      assignment.deadLine.toString() +
      "/" +
      assignment.leftTime +
      "/" +
      assignment.done.toString());
}
