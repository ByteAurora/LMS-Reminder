class Schedule {
  /// 컬럼 - ID.
  static const String columnId = 'id';

  /// 컬럼 - 주차 정보.
  static const String columnWeek = 'week';

  /// 컬럼 - 활동 종류.
  static const String columnActivityType = 'activity_type';

  /// 컬럼 - 과목.
  static const String columnCourseTitle = 'course_title';

  /// 컬럼 - 활동명.
  static const String columnActivityTitle = 'activity_title';

  /// 컬럼 - 활동마감시간.
  static const String columnActivityDeadLine = 'activity_deadline';

  /// 컬럼 - 남은시간.
  static const String columnActivityLeftTime = 'activity_lefttime';
  
  /// 컬럼 - 상태
  static const String columnActivityState = 'activity_state';

  String? id;
  String? activityType;
  String? week;
  String? courseTitle;
  String? activityTitle;
  String? activityDeadLine;
  String? activityLeftTime;
  bool? activityState;

  Schedule(this.id, this.activityType, this.week, this.courseTitle,
      this.activityTitle, this.activityDeadLine, this.activityLeftTime, this.activityState);

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnWeek: week,
      columnActivityType: activityType,
      columnCourseTitle: courseTitle,
      columnActivityTitle: activityTitle,
      columnActivityDeadLine: activityDeadLine,
      columnActivityLeftTime: activityLeftTime,
      columnActivityState: activityState
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
        mapData[columnActivityLeftTime],
        mapData[columnActivityState]);
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
