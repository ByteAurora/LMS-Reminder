import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;

/// 동영상 강의 정보를 관리하는 클래스.
class Video {
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
          video.title = tdList[1].text;
          video.requiredWatchTime = tdList[2].text;
          video.watch = tdList[4].text.contains('O');

          if (video.watch) {
            video.totalWatchTime = tdList[3]
                .innerHtml
                .substring(0, tdList[3].innerHtml.indexOf('<'));
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
        video.title = tdList[0].text;
        video.requiredWatchTime = tdList[1].text;
        video.watch = tdList[3].text.contains('O');

        if (video.watch) {
          video.totalWatchTime = tdList[2]
              .innerHtml
              .substring(0, tdList[2].innerHtml.indexOf('<'));
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

  DateTime get deadLine => _deadLine!;

  set deadLine(DateTime value) {
    _deadLine = value;
  }
}
