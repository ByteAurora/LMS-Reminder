
import 'package:flutter/material.dart';
import 'package:lms_reminder/manager/lms_manager.dart';
import 'package:lms_reminder/model/course.dart';
import 'package:lms_reminder/model/notice.dart';
import 'package:shimmer/shimmer.dart';

import '../manager/lms_manager.dart';

class TabPageNotice extends StatefulWidget {
  final Function() notifyParent;

  const TabPageNotice({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State createState() {
    return _TabPageNotice();
  }
}

class _TabPageNotice extends State<TabPageNotice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: LmsManager().getAllNoticeList(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
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
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Shimmer.fromColors(
                                              // 과목명[주차]
                                              baseColor: Colors.grey.shade400,
                                              highlightColor:
                                                  Colors.grey.shade300,
                                              child: Container(
                                                height: 24,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Shimmer.fromColors(
                                            // 과제, 동영상 아이콘
                                            baseColor: Colors.grey.shade400,
                                            highlightColor:
                                                Colors.grey.shade300,
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0, right: 8.0),
                                              child: Shimmer.fromColors(
                                                // 과제, 동영상 제목
                                                baseColor: Colors.grey.shade400,
                                                highlightColor:
                                                    Colors.grey.shade300,
                                                child: Container(
                                                  height: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Shimmer.fromColors(
                                // 남은시간 영역
                                baseColor: Colors.grey.shade400,
                                highlightColor: Colors.grey.shade300,
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(64),
                                    ),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              List<dynamic> todoList = (snapshot.data as List<dynamic>);
              if (todoList.isEmpty) {
                return const Text('공지가 없습니다.');
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
                            String? noticeTitle;
                            String? noticeContent;
                            String? noticeAuthor;
                            String? noticeDate;
                            String? noticeCourse;
                            Notice notice = todoList.elementAt(index) as Notice;
                            noticeTitle = notice.title;
                            noticeContent = notice.content;
                            noticeAuthor = notice.author;
                            noticeDate = notice.date;
                            noticeCourse = notice.course.title;
                            ///공지사항 출력
                            return ExpansionTile(
                              title: Text(noticeTitle),
                              subtitle: Text("["+noticeDate +"]" + noticeCourse,
                                style: TextStyle(color: Colors.grey),
                              ),

                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      Text("작성자: " + noticeAuthor),
                                      Text(noticeContent),
                                    ],
                                  ),
                                ),
                              ],
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
