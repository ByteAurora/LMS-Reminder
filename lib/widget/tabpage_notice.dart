import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:lms_reminder/manager/lms_manager.dart';
import 'package:lms_reminder/model/notice.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

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
            if (snapshot.hasData == true) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: [
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
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Shimmer.fromColors(
                                                //제목 
                                                baseColor: Colors.grey.shade400,
                                                highlightColor:
                                                    Colors.grey.shade300,
                                                child: Container(
                                                  height: 33,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 230.0),
                                                child: Shimmer.fromColors(
                                                  //부제목
                                                  baseColor:
                                                      Colors.grey.shade400,
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                            return Card(
                              child: ExpansionTile(
                                title: Text(noticeTitle),
                                subtitle: Text(
                                  "[" + noticeDate + "]" + noticeCourse,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        Text("작성자: " + noticeAuthor),
                                        Html(
                                          data: noticeContent,
                                          onLinkTap: (String? url,
                                              RenderContext renderContext,
                                              Map<String, String> attributes,
                                              html_dom.Element? element) async {
                                            await launchUrl(Uri.parse(url!),
                                                mode: LaunchMode.inAppWebView);
                                          },
                                        ),
                                      ],
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
