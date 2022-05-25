import 'package:flutter/material.dart';
import 'package:lms_reminder/manager/lms_manager.dart';
import 'package:lms_reminder/model/assignment.dart';
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
          future: LmsManager().getNoticeList(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 1,
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
                            String? auther;
                            Notice notice = todoList.elementAt(index) as Notice;
                            noticeTitle = notice.title;

                            return Card(
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
                                                      noticeTitle!,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      auther!,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
