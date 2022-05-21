import '../manager/schedule_manager.dart';

class Schedule {
  String? id;
  String? activityType;
  String? week;
  String? courseTitle;
  String? activityTitle;
  String? activityDeadLine;

  Schedule(
      this.id,
      this.activityType,
      this.week,
      this.courseTitle,
      this.activityTitle,
      this.activityDeadLine);

  Map<String, dynamic> toMap() {
    return {
      ScheduleManager.columnId: id,
      ScheduleManager.columnWeek: week,
      ScheduleManager.columnActivityType: activityType,
      ScheduleManager.columnCourseTitle: courseTitle,
      ScheduleManager.columnActivityTitle: activityTitle,
      ScheduleManager.columnActivityDeadLine: activityDeadLine
    };
  }

  @override
  String toString() {
    return id! + "/" + week! + "/" + activityType! + "/" + courseTitle! + "/" + activityTitle! + "/" + activityDeadLine!;
  }
}
