import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

import '../manager/dio_manager.dart';
import '../manager/lms_manager.dart';
import '../model/assignment.dart';
import '../model/video.dart';

class TabPageFinished extends StatefulWidget {
  final Function() notifyParent;

  const TabPageFinished({Key? key, required this.notifyParent})
      : super(key: key);

  @override
  State createState() {
    return _TabPageFinished();
  }
}

class _TabPageFinished extends State<TabPageFinished> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: LmsManager().getFinishedList(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return const CircularProgressIndicator();
            } else {
              List<dynamic> todoList = (snapshot.data as List<dynamic>);
              if (todoList.isEmpty) {
                return const Text('한 일이 없네요...');
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshAllData,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: todoList.length,
                          itemBuilder: (context, index) {
                            String? courseTitle;
                            String? week;
                            String? activityTitle;
                            Image? activityImage;
                            String? deadLine;
                            String? leftTime;
                            Color? leftTimeCircleColor;
                            bool? state;
                            String? content;

                            if (todoList.elementAt(index).runtimeType ==
                                Assignment) {
                              Assignment assignment =
                                  todoList.elementAt(index) as Assignment;
                              courseTitle = assignment.lecture.course.title;
                              week = assignment.lecture.week;
                              activityTitle = assignment.title;
                              activityImage = const Image(
                                image: AssetImage(
                                    'resource/image/icon_assignment.png'),
                                width: 24,
                                height: 24,
                                fit: BoxFit.fill,
                              );
                              deadLine = DateFormat('yyyy년 MM월 dd일 HH시 mm분')
                                  .format(assignment.deadLine);
                              leftTime = assignment.getLeftTime();
                              content = assignment.content;
                              state = assignment.submit;
                            } else {
                              Video video = todoList.elementAt(index) as Video;
                              courseTitle = video.lecture.course.title;
                              week = video.lecture.week;
                              activityTitle = video.title;
                              activityImage = const Image(
                                image:
                                    AssetImage('resource/image/icon_video.png'),
                                width: 24,
                                height: 24,
                                fit: BoxFit.fill,
                              );
                              deadLine = DateFormat('yyyy년 MM월 dd일 00시 00분')
                                  .format(video.deadLine);
                              leftTime = video.getLeftTime();
                              state = video.watch;
                            }

                            if (leftTime == '마감') {
                              leftTimeCircleColor = Colors.grey;
                            } else if (leftTime == 'D-1' ||
                                !leftTime.contains('D')) {
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 14,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        '주차: ' + week!,
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        '마감일: ' + deadLine!,
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (content != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            left: 8.0,
                                                            right: 8.0),
                                                    child: Html(
                                                      data: content,
                                                      onLinkTap: (String? url,
                                                          RenderContext
                                                              renderContext,
                                                          Map<String, String>
                                                              attributes,
                                                          html_dom.Element?
                                                              element) async {
                                                        if (await Permission
                                                            .manageExternalStorage
                                                            .request()
                                                            .isDenied) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            content:
                                                                Text('권한 거부됨'),
                                                            duration:
                                                                Duration(
                                                                    seconds: 1),
                                                          ));
                                                        } else {
                                                          String decodeUrl = Uri
                                                              .decodeComponent(
                                                                  url!);
                                                          String fileName = decodeUrl.substring(
                                                              decodeUrl.indexOf(
                                                                      '/0/') +
                                                                  3,
                                                              decodeUrl.indexOf(
                                                                  '?forcedownload'));
                                                          String fileExtension =
                                                              fileName.substring(
                                                                  fileName
                                                                      .lastIndexOf(
                                                                          '.'));
                                                          fileName = fileName
                                                              .substring(
                                                                  0,
                                                                  fileName
                                                                      .lastIndexOf(
                                                                          '.'));

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
                                                              fileName +
                                                                  fileExtension;
                                                          while (file
                                                              .existsSync()) {
                                                            finalFileName = fileName +
                                                                '(' +
                                                                loop.toString() +
                                                                ')' +
                                                                fileExtension;
                                                            filePath =
                                                                '/storage/emulated/0/Download/' +
                                                                    finalFileName;
                                                            file =
                                                                File(filePath);
                                                            loop++;
                                                          }

                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text("'" +
                                                                finalFileName +
                                                                "' 다운로드 시작"),
                                                            duration:
                                                                const Duration(
                                                                    seconds: 1),
                                                          ));

                                                          DioManager()
                                                              .httpGetFile(
                                                                  url!, file,
                                                                  () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text("'" +
                                                                    finalFileName +
                                                                    "' 다운로드 완료"),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            3),
                                                                action:
                                                                    SnackBarAction(
                                                                  label: '열기',
                                                                  onPressed:
                                                                      () {
                                                                    OpenFile.open(
                                                                        file.path);
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                          dialogType: state!
                                              ? DialogType.SUCCES
                                              : DialogType.ERROR,
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        courseTitle,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Text(
                                                        " [" + week + "]",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Row(
                                                      children: [
                                                        activityImage,
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 4),
                                                          child: Text(
                                                            activityTitle,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
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
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(64),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
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
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> _refreshAllData() async {
    await LmsManager().refreshAllData();
    widget.notifyParent();
  }
}
