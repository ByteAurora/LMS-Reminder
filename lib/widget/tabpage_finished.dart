import 'package:flutter/material.dart';

import '../manager/lms_manager.dart';
import '../model/assignment.dart';
import '../model/video.dart';

class TabPageFinished extends StatefulWidget {
  const TabPageFinished({Key? key}) : super(key: key);

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
            if (snapshot.hasData == false || LmsManager.isLoading) {
              return const CircularProgressIndicator();
            } else {
              List<dynamic> todoList = (snapshot.data as List<dynamic>);
              if (todoList.isEmpty) {
                return const Text('한 일이 없네요...');
              } else {
                return Expanded(
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
                        String? leftTime;
                        Color? leftTimeCircleColor;

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
                          leftTime = assignment.getLeftTime();
                        } else {
                          Video video = todoList.elementAt(index) as Video;
                          courseTitle = video.lecture.course.title;
                          week = video.lecture.week;
                          activityTitle = video.title;
                          activityImage = const Image(
                            image: AssetImage(
                                'resource/image/icon_video.png'),
                            width: 24,
                            height: 24,
                            fit: BoxFit.fill,
                          );
                          leftTime = video.getLeftTime();
                        }

                        if(leftTime == '마감') {
                          leftTimeCircleColor = Colors.grey;
                        } else if(leftTime == 'D-1' || !leftTime.contains('D')) {
                          leftTimeCircleColor = Colors.redAccent;
                        } else {
                          leftTimeCircleColor = Colors.lightBlueAccent;
                        }

                        return Card(
                          child: InkWell(
                            onTap: () {},
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
                                              Text(
                                                courseTitle + " [" + week + "]",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  children: [
                                                    activityImage,
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4),
                                                      child: Text(
                                                        activityTitle,
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
    setState(() {});
  }
}
