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
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              if (todoList.elementAt(index).runtimeType ==
                                  Assignment) ...[
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
                                                (todoList.elementAt(index)
                                                        as Assignment)
                                                    .lecture
                                                    .course
                                                    .title + " [" + (todoList.elementAt(index)
                                                as Assignment).lecture.week + "]",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                    (todoList.elementAt(index)
                                                            as Assignment)
                                                        .title),
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
                                              (todoList.elementAt(index)
                                                      as Assignment)
                                                  .getLeftTime(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.0,
                                              ),
                                            ),
                                          ),
                                          width: 72,
                                          height: 72,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ] else if (todoList
                                      .elementAt(index)
                                      .runtimeType ==
                                  Video) ...[
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
                                                (todoList.elementAt(index)
                                                        as Video)
                                                    .lecture
                                                    .course
                                                    .title + " [" + (todoList.elementAt(index)
                                                as Video).lecture.week + "]",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                    (todoList.elementAt(index)
                                                            as Video)
                                                        .title),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
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
                                              (todoList.elementAt(index)
                                                      as Video)
                                                  .getLeftTime(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.0,
                                              ),
                                            ),
                                          ),
                                          width: 72,
                                          height: 72,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
