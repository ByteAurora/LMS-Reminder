import 'dart:core';
import 'dart:io';

import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:lms_reminder/model/assignment.dart';
import 'package:lms_reminder/model/lecture.dart';

/// Html에서 Lecture 관련 정보 파싱 테스트.
Future<void> main() async {
  // 테스트할 강의목록 html 경로
  String filePath =
      'D:\\lms_reminder\\others\\LMS page html sample\\LMS 강의정보 - full html code.html';

  String htmlContents = await File(filePath).readAsString();

  html_dom.Document document = html_parser.parse(htmlContents);
  document
      .getElementById('region-main')!
      .getElementsByTagName('div')[0]
      .getElementsByClassName('course-content')[0]
      .getElementsByClassName('total_sections')[0]
      .getElementsByClassName('course_box')[0]
      .getElementsByClassName('weeks ubsweeks')[0]
      .getElementsByTagName('li')
      .forEach((element) {
    if (element.className.contains("section main clearfix")) {
      Lecture lecture = Lecture();

      String sectionName =
          element.getElementsByClassName('hidden sectionname')[0].text;
      lecture.week = sectionName.substring(0, sectionName.indexOf(" "));
      lecture.date = sectionName.substring(
          sectionName.indexOf("[") + 1, sectionName.indexOf("]"));

      List<html_dom.Element> activities = element
          .getElementsByClassName('content')[0]
          .getElementsByClassName('section img-text');

      if (activities.isNotEmpty) {
        activities[0]
            .getElementsByClassName('activity assign modtype_assign ')
            .forEach((element2) {
          Assignment assignment = Assignment();

          html_dom.Element assignmentElement = element2
              .getElementsByTagName('div')[0]
              .getElementsByClassName('mod-indent-outer')[0]
              .getElementsByTagName('div')[1]
              .getElementsByClassName('activityinstance')[0];

          assignment.title = assignmentElement.getElementsByTagName('a')[0].getElementsByClassName('instancename')[0].text;
          assignment.url = assignmentElement.innerHtml.substring(assignmentElement.innerHtml.indexOf("href=") + 6, assignmentElement.innerHtml.indexOf("\">"));

          print(assignment.title + " / " + assignment.url);
        });
      }
    }
  });
}