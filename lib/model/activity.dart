import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:lms_reminder/model/schedule.dart';
import 'package:lms_reminder/model/week.dart';

/// 활동 클래스.
class Activity {
  Week? _week;
  String? _type;
  String? _title;
  bool? _done;
  DateTime? _deadLine;

  Activity(String type, {Week? week}) {
    _type = type;
    _week = week;
  }

  Week get week => _week!;

  set week(Week week) {
    _week = week;
  }

  String get title => _title!;

  set title(String value) {
    _title = value;
  }

  DateTime get deadLine => _deadLine!;

  set deadLine(DateTime value) {
    _deadLine = value;
  }

  bool get done => _done!;

  set done(bool value) {
    _done = value;
  }

  String get type => _type!;

  set type(String value) {
    _type = value;
  }

  String getLeftTime() {
    DateTime currentTime = DateTime.now();
    if (deadLine.isBefore(currentTime)) {
      return '마감';
    }

    String result = "";
    Duration leftTime = deadLine.difference(currentTime);

    if (leftTime.inMinutes < 1440) {
      // 남은 시간이 하루보다 적을 경우 시간 형식으로 반환.
      String hour = (leftTime.inMinutes ~/ 60).toString().length == 1
          ? '0' + (leftTime.inMinutes ~/ 60).toString()
          : (leftTime.inMinutes ~/ 60).toString();
      String minute = (leftTime.inMinutes % 60).toInt().toString().length == 1
          ? '0' + (leftTime.inMinutes % 60).toString()
          : (leftTime.inMinutes % 60).toString();
      return hour + ":" + minute;
    }

    // 남은 시간이 하루보다 많을 경우 D-? 형식으로 반환.
    result = leftTime.inDays.toString();

    return 'D-' + result;
  }

  Schedule toSchedule(String leftTime) {
    return Schedule(
        sha256.convert(utf8.encode(title + leftTime)).toString(),
        type,
        week.title,
        week.course.title,
        title,
        DateFormat('yyyy-MM-dd HH:mm').format(deadLine),
        leftTime,
        done);
  }
}
