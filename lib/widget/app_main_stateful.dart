import 'package:flutter/material.dart';
import 'package:lms_reminder/widget/all_assignment_page.dart';
import 'package:lms_reminder/widget/finished_assignment_page.dart';
import 'package:lms_reminder/widget/unfinished_assignment_page.dart';

/// 최상위 Stateful Widget.
class AppMainStateful extends StatefulWidget {
  const AppMainStateful({Key? key, required this.appBarTitle})
      : super(key: key);

  final String? appBarTitle;

  @override
  State<AppMainStateful> createState() => _AppMainStatefulState();
}

class _AppMainStatefulState extends State<AppMainStateful>
    with SingleTickerProviderStateMixin {
  final pages = <Widget>[
    const AllAssignmentPage(),
    const UnfinishedAssignmentPage(),
    const FinishedAssignmentPage()
  ];

  final tabs = <Tab>[
    const Tab(
      icon: Icon(Icons.assignment),
      text: '과제',
      iconMargin: EdgeInsets.only(bottom: 4),
    ),
    const Tab(
      icon: Icon(Icons.assignment_late),
      text: '미제출',
      iconMargin: EdgeInsets.only(bottom: 4),
    ),
    const Tab(
      icon: Icon(Icons.assignment_turned_in_rounded),
      text: '제출',
      iconMargin: EdgeInsets.only(bottom: 4),
    ),
  ];

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle!),
      ),
      body: TabBarView(
        children: pages,
        controller: tabController,
      ),
      bottomNavigationBar: Material(
        color: Colors.blue[700],
        child: SizedBox(
          height: 64.0,
          child: TabBar(
            tabs: tabs,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[400],
            controller: tabController,
          ),
        ),
      ),
    );
  }
}
