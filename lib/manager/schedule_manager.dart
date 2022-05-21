import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/schedule.dart';

/// 활동 마감 전 알림 스케줄들을 관리하는 클래스.
class ScheduleManager {
  /// ScheduleManager 객체.
  static final ScheduleManager _instance = ScheduleManager._constructor();

  /// 데이터베이스명.
  static const String _databaseName = 'lms_reminder.db';

  /// 테이블명.
  static const String _tableName = 'schedule';

  /// 테이블 컬럼 - ID.
  static const String columnId = 'id';

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

  /// 데이터베이스 객체.
  Database? _database;

  /// Singleton 패턴 구현.
  ScheduleManager._constructor();
  factory ScheduleManager() {
    return _instance;
  }

  /// ScheduleManager 사용 전 초기화하는 함수.
  Future<void> init() async {
    // schedule 테이블이 없을 경우 생성.
    _database = await openDatabase(
        join(await getDatabasesPath(), _databaseName), onCreate: (db, version) {
      return db.execute('create table if not exists schedule(' +
          columnId +
          ' varchar(64) primary key,' +
          columnActivityType +
          ' integer,' +
          columnCourseTitle +
          ' varchar(20),' +
          columnActivityTitle +
          ' varchar(50),' +
          columnActivityDeadLine +
          ' varchar(16),' +
          columnAlert6Hours +
          ' boolean,' +
          columnAlert1Day +
          ' boolean,' +
          columnAlert3Days +
          ' boolean,' +
          columnAlert5Days +
          ' boolean);');
    }, version: 1);
  }

  /// Schedule 객체를 데이터베이스에 추가하는 함수.
  Future<bool> insert(Schedule schedule) async {
    return await _database!.insert(_tableName, schedule.toMap()) != 0;
  }

  /// 전달된 Schedule 객체를 데이터베이스에서 찾아 업데이트하는 함수.
  Future<bool> update(Schedule schedule) async {
    return await _database!.update(_tableName, schedule.toMap()) != 0;
  }

  /// 등록된 모든 Schedule 객체를 반환해주는 함수.
  Future<List<Schedule>> selectAll() async {
    List<Map<String, dynamic>> schedules = await _database!.query(_tableName);
    return List.generate(schedules.length, (index) {
      return Schedule(
          schedules[index][columnId],
          schedules[index][columnActivityType],
          schedules[index][columnCourseTitle],
          schedules[index][columnActivityTitle],
          schedules[index][columnActivityDeadLine],
          schedules[index][columnAlert6Hours],
          schedules[index][columnAlert1Day],
          schedules[index][columnAlert3Days],
          schedules[index][columnAlert5Days]);
    });
  }

  /// 전달된 ID값에 해당하는 Schedule 객체를 반환해주는 함수.
  Future<Schedule?> select(String id) async {
    List<Map<String, dynamic>> schedules = await _database!
        .query(_tableName, where: '$columnId=?', whereArgs: [id]);

    if (schedules.isEmpty) {
      return null;
    }

    List<Schedule> convertedSchedules =
        List.generate(schedules.length, (index) {
      return Schedule(
          schedules[index][columnId],
          schedules[index][columnActivityType],
          schedules[index][columnCourseTitle],
          schedules[index][columnActivityTitle],
          schedules[index][columnActivityDeadLine],
          schedules[index][columnAlert6Hours],
          schedules[index][columnAlert1Day],
          schedules[index][columnAlert3Days],
          schedules[index][columnAlert5Days]);
    });

    return convertedSchedules.elementAt(0);
  }

  /// 전달받은 모든 활동들을 WorkManager 서비스에 등록.
  Future updateSchedules(List<dynamic> activities) async {

  }
}
