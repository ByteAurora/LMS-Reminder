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

  /// 테이블 컬럼 - 남은시간.
  static const String columnActivityLeftTime = 'activity_lefttime';

  String? id;
  String? activityType;
  String? week;
  String? courseTitle;
  String? activityTitle;
  String? activityDeadLine;
  String? activityLeftTime;

  Schedule(this.id, this.activityType, this.week, this.courseTitle,
      this.activityTitle, this.activityDeadLine, this.activityLeftTime);

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnWeek: week,
      columnActivityType: activityType,
      columnCourseTitle: courseTitle,
      columnActivityTitle: activityTitle,
      columnActivityDeadLine: activityDeadLine,
      columnActivityLeftTime: activityLeftTime
    };
  }

  static Schedule fromMap(Map<String, dynamic> mapData) {
    return Schedule(
        mapData[columnId],
        mapData[columnActivityType],
        mapData[columnWeek],
        mapData[columnCourseTitle],
        mapData[columnActivityTitle],
        mapData[columnActivityDeadLine],
        mapData[columnActivityLeftTime]);
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
