/// 과제 정보를 관리하는 클래스.
class Assignment {
  /// 제목.
  String? _title;

  /// 과제 설명 및 내용.
  String? _content;

  /// 제출 상태.
  bool? _submitState;

  /// 마감일.
  DateTime? _deadLine;

  /// 남은 기한.
  String? _leftTime;

  String get title => _title!;

  set title(String value) {
    _title = value;
  }

  String get content => _content!;

  set content(String value) {
    _content = value;
  }

  bool get submitState => _submitState!;

  String get leftTime => _leftTime!;

  set leftTime(String value) {
    _leftTime = value;
  }

  DateTime get deadLine => _deadLine!;

  set deadLine(DateTime value) {
    _deadLine = value;
  }

  set submitState(bool value) {
    _submitState = value;
  }
}