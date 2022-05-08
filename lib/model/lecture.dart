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
