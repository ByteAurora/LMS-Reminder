import 'package:flutter/material.dart';
import 'package:lms_reminder/widget/widget_listview.dart';
import 'package:lms_reminder/widget/widget_shimmer.dart';

import '../manager/lms_manager.dart';

class TabPageFinished extends StatefulWidget {
  final Function() notifyParent;

  const TabPageFinished({Key? key, required this.notifyParent})
      : super(key: key);

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
          future: LmsManager().getFinishedActivityList(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return getShimmerActivity();
            } else {
              List<dynamic> finishedList = (snapshot.data as List<dynamic>);
              if (finishedList.isEmpty) {
                return const Text('한 일이 없네요...');
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshAllData,
                        child: getActivityListview(finishedList),
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
