import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:intl/intl.dart';
import 'package:lms_reminder/widget/snackbar.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../manager/dio_manager.dart';
import '../model/activity.dart';
import '../model/assignment.dart';
import '../model/video.dart';

Widget getActivityListview(List<dynamic> activityList) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: activityList.length,
    itemBuilder: (context, index) {
      String? courseTitle;
      String? weekTitle;
      String? activityTitle;
      Icon? activityIcon;
      DateTime? deadLine;
      String? strDeadLine;
      String? leftTime;
      Color? leftTimeCircleColor;
      bool? done;
      String? content;
      String? videoLength;
      String? totalWatchTime;

      Activity activity = activityList.elementAt(index) as Activity;
      courseTitle = activity.week.course.title;
      weekTitle = activity.week.title;
      activityTitle = activity.title;
      deadLine = activity.deadLine;
      strDeadLine =
          DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(activity.deadLine);
      leftTime = activity.getLeftTime();
      done = activity.done;

      if (activityList.elementAt(index).runtimeType == Assignment) {
        activityIcon = const Icon(
          Icons.assignment,
          size: 24.0,
          color: Colors.lightGreen,
        );
        content = (activityList.elementAt(index) as Assignment).content;
      } else {
        Video video = activityList.elementAt(index) as Video;
        activityIcon = const Icon(
          Icons.ondemand_video,
          size: 24.0,
          color: Colors.red,
        );
        videoLength = video.videoLength;
        totalWatchTime = video.totalWatchTime;
      }

      if (leftTime == '마감') {
        leftTimeCircleColor = Colors.grey;
      } else if (leftTime == 'D-1' || !leftTime.contains('D')) {
        leftTimeCircleColor = Colors.redAccent;
      } else {
        leftTimeCircleColor = Colors.lightBlueAccent;
      }

      return Card(
        child: InkWell(
          onTap: () {
            AwesomeDialog(
                    context: context,
                    headerAnimationLoop: false,
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            courseTitle!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            activityTitle!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Visibility(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.timer,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SlideCountdownSeparated(
                                    duration:
                                        deadLine!.difference(DateTime.now()),
                                  ),
                                ],
                              ),
                              visible: deadLine.isAfter(DateTime.now()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 14,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '주차: ' + weekTitle!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '마감일: ' + strDeadLine!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                if (videoLength != null) ...[
                                  Text(
                                    '동영상 길이: ' + videoLength,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    '시청 시간: ' + totalWatchTime!,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (content != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0),
                              child: Html(
                                data: content,
                                onLinkTap: (String? url,
                                    RenderContext renderContext,
                                    Map<String, String> attributes,
                                    html_dom.Element? element) async {
                                  await Permission.storage.request();

                                  if (await Permission.storage.isDenied) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text('저장소 접근 권한이 필요합니다'),
                                      duration: const Duration(seconds: 3),
                                      action: SnackBarAction(
                                          label: '설정',
                                          onPressed: () {
                                            openAppSettings();
                                          }),
                                    ));
                                    return;
                                  }

                                  if ((await DeviceInfoPlugin().androidInfo)
                                          .version
                                          .sdkInt! >=
                                      30) {
                                    await Permission.manageExternalStorage
                                        .request();

                                    if (await Permission
                                        .manageExternalStorage.isDenied) {
                                      showSnackBar(
                                          context, '저장소 관리 권한이 필요합니다', 3,
                                          actionText: '설정', onPressed: () {
                                        openAppSettings();
                                      });
                                      return;
                                    }
                                  }

                                  String decodeUrl = Uri.decodeComponent(url!);
                                  String fileName = decodeUrl.substring(
                                      decodeUrl.indexOf('/0/') + 3,
                                      decodeUrl.indexOf('?forcedownload'));
                                  String fileExtension = fileName
                                      .substring(fileName.lastIndexOf('.'));
                                  fileName = fileName.substring(
                                      0, fileName.lastIndexOf('.'));

                                  File file = File(
                                      '/storage/emulated/0/Download/' +
                                          fileName +
                                          fileExtension);

                                  int loop = 1;
                                  String filePath =
                                      '/storage/emulated/0/Download/' +
                                          fileName +
                                          fileExtension;

                                  String finalFileName =
                                      fileName + fileExtension;
                                  while (file.existsSync()) {
                                    finalFileName = fileName +
                                        '(' +
                                        loop.toString() +
                                        ')' +
                                        fileExtension;
                                    filePath = '/storage/emulated/0/Download/' +
                                        finalFileName;
                                    file = File(filePath);
                                    loop++;
                                  }

                                  showSnackBar(context,
                                      "'" + finalFileName + "' 다운로드 시작", 1);

                                  DioManager().downloadFileFromUrl(url, file,
                                      () {
                                    // 파일이 성공적으로 다운로드 되었을 경우.
                                    showSnackBar(context,
                                        "'" + finalFileName + "' 다운로드 완료", 3,
                                        actionText: '열기', onPressed: () async {
                                      if ((await OpenFile.open(file.path))
                                              .type ==
                                          ResultType.noAppToOpen) {
                                        // 해당 파일을 실행할 수 있는 앱이 없을 경우
                                        showSnackBar(
                                            context, '파일을 열 수 있는 앱이 없습니다', 2,
                                            actionText: '검색',
                                            onPressed: () async {
                                          String playStoreUrl =
                                              'https://play.google.com/store/search?q=open ' +
                                                  fileExtension.replaceAll(
                                                      '.', '') +
                                                  '&c=apps';
                                          await launchUrl(
                                              Uri.parse(playStoreUrl));
                                        });
                                      }
                                    });
                                  }, () {
                                    // 파일 다운로드에 실패했을 경우.
                                    showSnackBar(context,
                                        "'" + finalFileName + "' 다운로드 실패", 2);
                                  });
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                    dialogType: done! ? DialogType.SUCCES : DialogType.ERROR,
                    animType: AnimType.SCALE,
                    btnOkText: '확인',
                    btnOkOnPress: () {})
                .show();
          },
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  courseTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  " [" + weekTitle + "]",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  activityIcon,
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      activityTitle,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: leftTimeCircleColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(64),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            leftTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        width: 64,
                        height: 64,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
