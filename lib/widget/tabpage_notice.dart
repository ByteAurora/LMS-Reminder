import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:lms_reminder/manager/lms_manager.dart';
import 'package:lms_reminder/model/notice.dart';
import 'package:lms_reminder/widget/widget_shimmer.dart';
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
          future: LmsManager().getNoticeList(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return getShimmerNotice();
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
                                  "[" + noticeDate + "] " + noticeCourse,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
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

  /// 모든 데이터 초기화 및 부모 위젯 업데이트. (다른 탭 페이지들도 업데이트 하기 위함)
  Future<void> _refreshAllData() async {
    await LmsManager().reloadAllDataFromLms();
    widget.notifyParent();
  }
}
