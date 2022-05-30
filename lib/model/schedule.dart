/// 알림 등록에 사용될 스케줄 클래스.
class Schedule {
  /// 컬럼 - 스케줄 ID.
  static const String columnId = 'id';

  /// 컬럼 - Notification ID.
  static const String columnNotificationId = 'notification_id';

  /// 컬럼 - 주차 제목.
  static const String columnWeekTitle = 'week_title';

  /// 컬럼 - 활동 종류.
  static const String columnActivityType = 'activity_type';

  /// 컬럼 - 강좌명.
  static const String columnCourseTitle = 'course_title';

  /// 컬럼 - 활동명.
  static const String columnActivityTitle = 'activity_title';

  /// 컬럼 - 활동마감시간.
  static const String columnActivityDeadLine = 'activity_deadline';

  /// 컬럼 - 남은시간.
  static const String columnActivityLeftTime = 'activity_lefttime';

  /// 컬럼 - 상태.
  static const String columnActivityState = 'activity_state';

  String? id;
  int? notificationId;
  String? activityType;
  String? weekTitle;
  String? courseTitle;
  String? activityTitle;
  String? activityDeadLine;
  String? activityLeftTime;
  bool? activityState;

  Schedule(
      this.id,
      this.notificationId,
      this.activityType,
      this.weekTitle,
      this.courseTitle,
      this.activityTitle,
      this.activityDeadLine,
      this.activityLeftTime,
      this.activityState);

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnNotificationId: notificationId,
      columnWeekTitle: weekTitle,
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
        mapData[columnNotificationId],
        mapData[columnActivityType],
        mapData[columnWeekTitle],
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
        weekTitle! +
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
