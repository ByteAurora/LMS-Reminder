import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;

import 'lecture.dart';

/// 동영상 강의 정보를 관리하는 클래스.
class Video {
  /// 주차.
  Lecture? _lecture;

  /// 영상 제목.
  String? _title;

  /// 시청 상태.
  bool? _watch;

  /// 출석인정 요구시간.
  String? _requiredWatchTime;

  /// 총 시청시간.
  String? _totalWatchTime;

  /// 활성화 시간.
  DateTime? _enableTime;

  /// 출석마감 시간.
  DateTime? _deadLine;

  /// 전달된 html에서 영상 정보를 추출하여 반환하는 함수.
  static List<List<Video>> parseVideosFromHtml(String html) {
    List<List<Video>> courseVideoList = List.empty(growable: true);

    html_dom.Document document = html_parser.parse(html);

    int maxRowCount = 0;
    int currentRowCount = 0;

    List<Video>? weekVideoList;
    document
        .getElementById('ubcompletion-progress-wrapper')!
        .getElementsByTagName('div')[1]
        .getElementsByClassName('table  table-bordered user_progress_table')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr')
        .forEach((element) {
      List<html_dom.Element> tdList = element.getElementsByTagName('td');

      if (tdList.length == 5) {
        if (element.innerHtml.contains('rowspan')) {
          weekVideoList = List.empty(growable: true);
          currentRowCount = 1;
          maxRowCount = int.parse(element.innerHtml.substring(
              element.innerHtml.indexOf('rowspan="') + 9,
              element.innerHtml.indexOf('">')));

          Video video = Video();
          video.title = tdList[1].text.trim();
          video.requiredWatchTime = tdList[2].text.trim();
          video.watch = tdList[4].text.contains('O');

          if (video.watch) {
            video.totalWatchTime = tdList[3]
                .innerHtml
                .substring(0, tdList[3].innerHtml.indexOf('<'))
                .trim();
          } else {
            video.totalWatchTime = "O0:00";
          }

          weekVideoList!.add(video);

          if (currentRowCount == maxRowCount) {
            courseVideoList.add(weekVideoList!);
          }
        } else {
          courseVideoList.add(List.empty());
        }
      } else {
        Video video = Video();
        video.title = tdList[0].text.trim();
        video.requiredWatchTime = tdList[1].text.trim();
        video.watch = tdList[3].text.contains('O');

        if (video.watch) {
          video.totalWatchTime = tdList[2]
              .innerHtml
              .substring(0, tdList[2].innerHtml.indexOf('<'))
              .trim();
        } else {
          video.totalWatchTime = "O0:00";
        }

        weekVideoList!.add(video);

        currentRowCount++;

        if (currentRowCount == maxRowCount) {
          courseVideoList.add(weekVideoList!);
        }
      }
    });

    return courseVideoList;
  }

  /// Video 생성자.
  Video({Lecture? lecture}) {
    _lecture = lecture;
  }

  /// 영상 출석 마감까지 남은 시간을 반환해주는 함수.
  String getLeftTime() {
    DateTime currentTime = DateTime.now();
    if (deadLine.isBefore(currentTime)) {
      return '마감';
    }

    String result = "";
    Duration leftTime = deadLine.difference(currentTime);

    if (leftTime.inMinutes < 1440) {
      String hour = (leftTime.inMinutes ~/ 60).toString().length == 1
          ? '0' + (leftTime.inMinutes ~/ 60).toString()
          : (leftTime.inMinutes ~/ 60).toString();
      String minute = (leftTime.inMinutes % 60).toInt().toString().length == 1
          ? '0' + (leftTime.inMinutes % 60).toString()
          : (leftTime.inMinutes % 60).toString();
      return hour + ":" + minute;
    }

    result = leftTime.inDays.toString();

    return 'D-' + result;
  }

  DateTime get deadLine => _deadLine!;

  set deadLine(DateTime value) {
    _deadLine = value;
  }

  Lecture get lecture => _lecture!;

  set lecture(Lecture value) {
    _lecture = value;
  }

  String get title => _title!;

  set title(String value) {
    _title = value;
  }

  String get requiredWatchTime => _requiredWatchTime!;

  bool get watch => _watch!;

  set watch(bool value) {
    _watch = value;
  }

  String get totalWatchTime => _totalWatchTime!;

  set totalWatchTime(String value) {
    _totalWatchTime = value;
  }

  set requiredWatchTime(String value) {
    _requiredWatchTime = value;
  }

  DateTime get enableTime => _enableTime!;

  set enableTime(DateTime value) {
    _enableTime = value;
  }
}
