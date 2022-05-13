import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:lms_reminder/model/assignment.dart';
import 'package:lms_reminder/model/video.dart';

/// 주차별 강의 정보를 관리하는 클래스.
class Lecture {
  /// 주차.
  String? _week;

  /// 기간.
  String? _date;

  /// 과제 목록.
  List<Assignment>? _assignmentList;

  /// 동영상 강의 목록.
  List<Video>? _videoList;

  /// 전달된 html에서 주차별 강의 정보를 추출하여 반환하는 함수.
  static List<Lecture> parseLecturesFromHtml(String html) {
    List<Lecture> lectureList = List.empty(growable: true);

    html_dom.Document document = html_parser.parse(html);
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

        List<Assignment> assignmentList = List.empty(growable: true);

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

            assignment.title = assignmentElement
                .getElementsByTagName('a')[0]
                .getElementsByClassName('instancename')[0]
                .text;
            assignment.url = assignmentElement.innerHtml.substring(
                assignmentElement.innerHtml.indexOf("href=") + 6,
                assignmentElement.innerHtml.indexOf("\">")).replaceAll('https://learn.hoseo.ac.kr', '');

            assignmentList.add(assignment);
          });
        }
        lecture.assignmentList = assignmentList;

        lectureList.add(lecture);
      }
    });

    return lectureList;
  }

  String get week => _week!;

  set week(String value) {
    _week = value;
  }

  String get date => _date!;

  set date(String value) {
    _date = value;
  }

  List<Assignment> get assignmentList => _assignmentList!;

  set assignmentList(List<Assignment> value) {
    _assignmentList = value;
  }

  List<Video> get videoList => _videoList!;

  set videoList(List<Video> value) {
    _videoList = value;
  }
}
