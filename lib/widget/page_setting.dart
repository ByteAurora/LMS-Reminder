import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lms_reminder/manager/lms_manager.dart';

class PageSetting extends StatefulWidget {
  const PageSetting({Key? key}) : super(key: key);

  @override
  State<PageSetting> createState() => _PageSettingState();
}

class _PageSettingState extends State<PageSetting> {
  /// 제출 or 시청 완료된 활동도 알림 (true, false)
  bool keyNotifyFinishedActivities = false;

  /// 동영상 출석 마감알림 여부 (true, false)
  bool keyNotifyVideo = false;

  /// 동영상 출석 마감 6시간 전 알림 (true, false)
  bool keyNotifyVideoBefore6Hours = false;

  /// 동영상 출석 마감 하루 전 알림 (true, false)
  bool keyNotifyVideoBefore1Day = false;

  /// 동영상 출석 마감 3일 전 알림 (true, false)
  bool keyNotifyVideoBefore3Days = false;

  /// 동영상 출석 마감 5일 전 알림 (true, false)
  bool keyNotifyVideoBefore5Days = false;

  /// 과제 마감알림 여부 (true, false)
  bool keyNotifyAssignment = false;

  /// 과제 마감 6시간 전 알림 (true, false)
  bool keyNotifyAssignmentBefore6Hours = false;

  /// 과제 마감 하루 전 알림 (true, false)
  bool keyNotifyAssignmentBefore1Day = false;

  /// 과제 마감 3일 전 알림 (true, false)
  bool keyNotifyAssignmentBefore3Day = false;

  /// 과제 마감 5일 전 알림 (true, false)
  bool keyNotifyAssignmentBefore5Day = false;

  /// 사용자 아이디 저장값 (string)
  String keyUserId = ' ';

  /// 사용자 비밀번호 저장값 (string)
  String keyUserPw = ' ';

  /// 튜토리얼 표시 여부 (true, false)
  bool keyTutorialShowed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
          children: <Widget>[
            Flexible(
              child:Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: [
                    Text("일반",
                      style:TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child:Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: [
                    Text("1.0.0"),
                  ],
                ),
              ),
            ),
            Flexible(
                child:Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Text("마감 전 알림",
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
            ),
            Flexible(
                child:SwitchListTile(
                    title: const Text("제출/시청 완료한 활동 알림"),
                    value: keyNotifyFinishedActivities,
                    onChanged: (value){
                      setState((){
                        keyNotifyFinishedActivities=value;
                      });
                    })
            ),
            Flexible(
                child:SwitchListTile(
                    title: const Text("동영상 알림"),
                    value: keyNotifyVideo,
                    onChanged: (value){
                      setState((){
                        keyNotifyVideo=value;
                      });
                    })
            ),
            Flexible(
                child:SwitchListTile(
                    title: const Text("6시간 전"),
                    value: keyNotifyVideoBefore6Hours,
                    onChanged: (value){
                      setState((){
                        keyNotifyVideoBefore6Hours=value;
                      });
                    })
            ),
            Flexible(
                child:SwitchListTile(
                    title: const Text("1일 전"),
                    value: keyNotifyVideoBefore1Day,
                    onChanged: (value){
                      setState((){
                        keyNotifyVideoBefore1Day=value;
                      });
                    })
            ),
            Flexible(
                child:SwitchListTile(
                    title: const Text("3일 전"),
                    value: keyNotifyVideoBefore3Days,
                    onChanged: (value){
                      setState((){
                        keyNotifyVideoBefore3Days=value;
                      });
                    })
            ),
            Flexible(
                child:SwitchListTile(
                    title: const Text("과제 알림"),
                    value: keyNotifyAssignment,
                    onChanged: (value){
                      setState((){
                        keyNotifyAssignment=value;
                      });
                    })
            ),
            Flexible(
                child:SwitchListTile(
                    title: const Text("6시간 전"),
                    value: keyNotifyAssignmentBefore6Hours,
                    onChanged: (value){
                      setState((){
                        keyNotifyAssignmentBefore6Hours=value;
                      });
                    })
            ),
            Flexible(
                child:SwitchListTile(
                    title: const Text("1일 전"),
                    value: keyNotifyAssignmentBefore1Day,
                    onChanged: (value){
                      setState((){
                        keyNotifyAssignmentBefore1Day=value;
                      });
                    })
            ),
            Flexible(
                child:SwitchListTile(
                    title: const Text("3일 전"),
                    value: keyNotifyAssignmentBefore3Day,
                    onChanged: (value){
                      setState((){
                        keyNotifyAssignmentBefore3Day=value;
                      });
                    })
            ),
            Flexible(
              child:Container(
                padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text("사용자",
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    children: <Widget>[
                      ElevatedButton(
                        child: Text("로그아웃"),
                        onPressed: (){
                          LmsManager().login(keyUserId, keyUserPw);
                          Navigator.popAndPushNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                ),
            ),
          ],
      ),
    );
  }
}
