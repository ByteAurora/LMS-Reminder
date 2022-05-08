/// 동영상 강의 정보를 관리하는 클래스.
class Video {
  /// 영상 제목.
  String? _title;

  /// 출석인정 요구시간.
  String? _requiredWatchTime;

  /// 총 시청시간.
  String? _totalWatchTime;

  /// 시청 상태.
  bool? _watchState;

  String get title => _title!;

  set title(String value) {
    _title = value;
  }

  String get requiredWatchTime => _requiredWatchTime!;

  bool get watchState => _watchState!;

  set watchState(bool value) {
    _watchState = value;
  }

  String get totalWatchTime => _totalWatchTime!;

  set totalWatchTime(String value) {
    _totalWatchTime = value;
  }

  set requiredWatchTime(String value) {
    _requiredWatchTime = value;
  }
}
