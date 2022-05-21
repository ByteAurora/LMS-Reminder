class Schedule {
  /// 테이블 컬럼 - ID.
  static const String columnId = 'id';

  /// 테이블 컬럼 - 주차 정보.
  static const String columnWeek = 'week';

  /// 테이블 컬럼 - 활동 종류.
  static const String columnActivityType = 'activity_type';

  /// 테이블 컬럼 - 과목.
  static const String columnCourseTitle = 'course_title';

  /// 테이블 컬럼 - 활동명.
  static const String columnActivityTitle = 'activity_title';

  /// 테이블 컬럼 - 활동마감시간.
  static const String columnActivityDeadLine = 'activity_deadline';

  /// 테이블 컬럼 - 6시간 전 알람 활성화 상태.
  static const String columnAlert6Hours = 'alert_6hours';

  /// 테이블 컬럼 - 1일 전 알람 활성화 상태.
  static const String columnAlert1Day = 'alert_1day';

  /// 테이블 컬럼 - 3일 전 알람 활성화 상태.
  static const String columnAlert3Days = 'alert_3days';

  /// 테이블 컬럼 - 5일 전 알람 활성화 상태.
  static const String columnAlert5Days = 'alert_5days';

  String? id;
  String? activityType;
  String? week;
  String? courseTitle;
  String? activityTitle;
  String? activityDeadLine;

  Schedule(this.id, this.activityType, this.week, this.courseTitle,
      this.activityTitle, this.activityDeadLine);

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnWeek: week,
      columnActivityType: activityType,
      columnCourseTitle: courseTitle,
      columnActivityTitle: activityTitle,
      columnActivityDeadLine: activityDeadLine
    };
  }

  static Schedule fromMap(Map<String, dynamic> mapData) {
    return Schedule(mapData[columnId], columnWeek, columnActivityType,
        columnCourseTitle, columnActivityTitle, columnActivityDeadLine);
  }

  @override
  String toString() {
    return id! +
        "/" +
        week! +
        "/" +
        activityType! +
        "/" +
        courseTitle! +
        "/" +
        activityTitle! +
        "/" +
        activityDeadLine!;
  }
}
