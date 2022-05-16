import 'package:flutter/material.dart';
import 'package:lms_reminder/manager/lms_manager.dart';

import '../model/assignment.dart';
import '../model/video.dart';

class TabPageNotFinished extends StatefulWidget {
  const TabPageNotFinished({Key? key}) : super(key: key);

  @override
  State createState() {
    return _TabPageNotFinished();
  }
}

class _TabPageNotFinished extends State<TabPageNotFinished> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: LmsManager().getNotFinishedList(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false || LmsManager.isLoading) {
              return const CircularProgressIndicator();
            } else {
              List<dynamic> todoList = (snapshot.data as List<dynamic>);
              if (todoList.isEmpty) {
                return const Text('할일이 없습니다!');
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
                                'resource/image/icon_assignment.png'),
                            width: 24,
                            height: 24,
                            fit: BoxFit.fill,
                          );
                          leftTime = video.getLeftTime();
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
                                            color: Color.fromARGB(
                                                255, 52, 128, 235),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(64),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 4,
                                                offset: Offset(4, 4),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              leftTime,
                                              style: TextStyle(
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
    setState(() {

    });
  }
}
