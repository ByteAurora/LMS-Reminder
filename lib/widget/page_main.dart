import 'package:flutter/material.dart';
import 'package:lms_reminder/widget/tabpage_finished.dart';
import 'package:lms_reminder/widget/tabpage_notfinished.dart';
import 'package:lms_reminder/widget/tabpage_notice.dart';

import '../manager/lms_manager.dart';

class PageMain extends StatefulWidget {
  final LmsManager lmsManager;

  final String? appBarTitle;

  const PageMain({Key? key, required this.lmsManager, required this.appBarTitle}) : super(key: key);

  @override
  State<PageMain> createState() => _PageMainState();
}

class _PageMainState extends State<PageMain>
    with SingleTickerProviderStateMixin {
  final pages = <Widget>[
    const TabPageNotFinished(),
    const TabPageFinished(),
    const TabPageNotice(),
  ];

  final tabs = <Tab>[
    const Tab(
      icon: Icon(Icons.assignment_late_outlined),
      text: '미완료',
      iconMargin: EdgeInsets.only(bottom: 4),
    ),
    const Tab(
      icon: Icon(Icons.assignment_turned_in_outlined),
      text: '완료',
      iconMargin: EdgeInsets.only(bottom: 4),
    ),
    const Tab(
      icon: Icon(Icons.circle_notifications_outlined),
      text: '공지사항',
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
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        title: Text(
          widget.appBarTitle!,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/main/setting');
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: TabBarView(
        children: pages,
        controller: tabController,
      ),
      bottomNavigationBar: Material(
        color: Colors.blue[700],
        child: ColoredBox(
          color: const Color.fromARGB(255, 183, 33, 45),
          child: SizedBox(
            height: 64.0,
            child: TabBar(
              tabs: tabs,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              controller: tabController,
            ),
          ),
        ),
      ),
    );
  }
}
