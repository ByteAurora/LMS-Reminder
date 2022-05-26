import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:lms_reminder/model/assignment.dart';
import 'package:lms_reminder/model/video.dart';

import 'course.dart';

/// 주차정보를 관리하는 클래스.
class Week {
  /// 강좌.
  Course? _course;

  /// 주차제목(ex. '1주차').
  String? _weekTitle;

  /// 기간.
  String? _date;

  /// 과제 목록.
  List<Assignment>? _assignmentList;

  /// 동영상 목록.
  List<Video>? _videoList;

  /// 전달된 html에서 주차 목록을 추출하여 반환하는 함수.
  static List<Week> parseWeekListFromHtml(Course course, String html) {
    List<Week> weekList = List.empty(growable: true);

    html_dom.Document document = html_parser.parse(html);

    String tempForNoticeUrl = document
        .getElementById('section-0')!
        .getElementsByClassName('content')[0]
        .getElementsByClassName('section img-text')[0]
        .getElementsByClassName('activity ubboard modtype_ubboard')[0]
        .getElementsByTagName('div')[4]
        .innerHtml;

    course.noticeListUrl = tempForNoticeUrl.substring(
        tempForNoticeUrl.indexOf('href="https://learn.hoseo.ac.kr') +
            'href="https://learn.hoseo.ac.kr'.length,
        tempForNoticeUrl.indexOf('">'));

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
        Week week = Week(course);

        String fullWeekTitle =
            element.getElementsByClassName('hidden sectionname')[0].text;
        week.weekTitle = fullWeekTitle.substring(0, fullWeekTitle.indexOf(" "));
        week.date = fullWeekTitle.substring(
            fullWeekTitle.indexOf("[") + 1, fullWeekTitle.indexOf("]"));

        List<Assignment> assignmentList = List.empty(growable: true);
        List<Video> videoList = List.empty(growable: true);

        List<html_dom.Element> activities = element
            .getElementsByClassName('content')[0]
            .getElementsByClassName('section img-text');

        if (activities.isNotEmpty) {
          for (var element2 in activities[0]
              .getElementsByClassName('activity assign modtype_assign ')) {
            Assignment assignment = Assignment(week);

            html_dom.Element assignmentElement = element2
                .getElementsByTagName('div')[0]
                .getElementsByClassName('mod-indent-outer')[0]
                .getElementsByTagName('div')[1]
                .getElementsByClassName('activityinstance')[0];

            if (assignmentElement.getElementsByTagName('a').isEmpty) {
              continue;
            }

            assignment.title = assignmentElement
                .getElementsByTagName('a')[0]
                .getElementsByClassName('instancename')[0]
                .text;
            assignment.url = assignmentElement.innerHtml
                .substring(assignmentElement.innerHtml.indexOf("href=") + 6,
                    assignmentElement.innerHtml.indexOf("\">"))
                .replaceAll('https://learn.hoseo.ac.kr', '');

            assignmentList.add(assignment);
          }

          activities[0]
              .getElementsByClassName('activity vod modtype_vod ')
              .forEach((element2) {
            Video video = Video(week: week);

            String videoInfo = element2
                .getElementsByTagName('div')[0]
                .getElementsByClassName('mod-indent-outer')[0]
                .getElementsByTagName('div')[1]
                .getElementsByClassName('activityinstance')[0]
                .getElementsByClassName('displayoptions')[0]
                .getElementsByClassName('text-ubstrap')[0]
                .text
                .trim();

            video.enableTime = DateTime.parse(videoInfo.substring(0, 19));
            video.deadLine = DateTime.parse(videoInfo.substring(22));

            videoList.add(video);
          });
        }
        week.assignmentList = assignmentList;
        week.videoList = videoList;

        weekList.add(week);
      }
    });

    return weekList;
  }

  /// Week 생성자.
  Week(Course course) {
    _course = course;
  }

  String get weekTitle => _weekTitle!;

  set weekTitle(String value) {
    _weekTitle = value;
  }

  Course get course => _course!;

  set course(Course value) {
    _course = value;
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
