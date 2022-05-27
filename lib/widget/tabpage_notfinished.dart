import 'package:flutter/material.dart';
import 'package:lms_reminder/manager/lms_manager.dart';
import 'package:lms_reminder/widget/widget_listview.dart';
import 'package:lms_reminder/widget/widget_shimmer.dart';

import '../manager/lms_manager.dart';

class TabPageNotFinished extends StatefulWidget {
  final Function() notifyParent;

  const TabPageNotFinished({Key? key, required this.notifyParent})
      : super(key: key);

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
          future: LmsManager().getNotFinishedActivityList(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return getShimmerActivity();
            } else {
              List<dynamic> notFinishedList = (snapshot.data as List<dynamic>);
              if (notFinishedList.isEmpty) {
                return const Text('할일이 없습니다!');
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshAllData,
                        child: getActivityListview(notFinishedList),
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
