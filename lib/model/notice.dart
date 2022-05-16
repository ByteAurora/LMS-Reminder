import 'course.dart';

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
