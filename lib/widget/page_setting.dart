
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lms_reminder/sharedpreference_key.dart';
import 'package:shared_preferences/shared_preferences.dart';



class PageSetting extends StatefulWidget {
  const PageSetting({Key? key}) : super(key: key);

  @override
  State<PageSetting> createState() => _PageSettingState();
}

class _PageSettingState extends State<PageSetting> {
  String? version="1.0.0";

  bool NotifyFinishedActivities=false;
  bool NotifyAssignmentSwitch=true;
  bool NotifyAssignment6HourSwitch=false;
  bool NotifyAssignment1daySwitch=true;
  bool NotifyAssignment3daysSwitch=false;
  bool NotifyAssignment5daysSwitch=false;
  bool NotifyVideo=true;
  bool NotifyVideo6Hours=false;
  bool NotifyVideo1day=true;
  bool NotifyVideo3days=false;
  bool NotifyVideo5days=false;

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
          Text("일반",style: TextStyle(fontSize: 30)),
          Padding(
            padding:EdgeInsets.all(10),
            child: Text("버전 : "+version!),
          ),
          Text("알림",style: TextStyle(fontSize: 30)),
          Padding(
            padding:EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SwitchListTile(
                    title: Text("제출/시청 완료한 알림"),
                    subtitle: Text("제출/시청 완료한 활동의 알림을 받습니다."),
                    value: NotifyFinishedActivities,
                    onChanged: (value) async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState((){
                        prefs.setBool(keyNotifyFinishedActivities, value);
                        NotifyFinishedActivities=prefs.getBool(keyNotifyFinishedActivities)!;
                      });
                    }
                ),
                SwitchListTile(
                    title: Text("과제 알림"),
                    subtitle: Text("과제 알람을 받습니다."),
                    value: NotifyAssignmentSwitch,
                    onChanged: (value) async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState((){
                        prefs.setBool(keyNotifyAssignment, value);
                        NotifyAssignmentSwitch=prefs.getBool(keyNotifyAssignment)!;
                        if(value==false){
                          prefs.setBool(keyNotifyAssignmentBefore6Hours, false);
                          NotifyAssignment6HourSwitch=prefs.getBool(keyNotifyAssignmentBefore6Hours)!;
                          prefs.setBool(keyNotifyAssignmentBefore1Day, false);
                          NotifyAssignment1daySwitch=prefs.getBool(keyNotifyAssignmentBefore1Day)!;
                          prefs.setBool(keyNotifyAssignmentBefore3Day, false);
                          NotifyAssignment3daysSwitch=prefs.getBool(keyNotifyAssignmentBefore3Day)!;
                          prefs.setBool(keyNotifyAssignmentBefore5Day, false);
                          NotifyAssignment5daysSwitch=prefs.getBool(keyNotifyAssignmentBefore5Day)!;
                        }
                      });
                    }
                ),
                ExpansionTile(
                  title:Text("알림주기"),
                  children: [
                    SwitchListTile(
                        title: Text("6시간 전"),
                        value: NotifyAssignment6HourSwitch,
                        onChanged: (value) async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState((){
                            if(prefs.getBool(keyNotifyAssignment)!){
                              prefs.setBool(keyNotifyAssignmentBefore6Hours, value);
                              NotifyAssignment6HourSwitch=prefs.getBool(keyNotifyAssignmentBefore6Hours)!;
                            }
                          });
                        }
                    ),
                    SwitchListTile(
                        title: Text("1일 전"),
                        value: NotifyAssignment1daySwitch,
                        onChanged: (value) async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState((){
                            if(prefs.getBool(keyNotifyAssignment)!){
                              prefs.setBool(keyNotifyAssignmentBefore1Day, value);
                              NotifyAssignment1daySwitch=prefs.getBool(keyNotifyAssignmentBefore1Day)!;
                            }
                          });
                        }
                    ),
                    SwitchListTile(
                        title: Text("3일 전"),
                        value: NotifyAssignment3daysSwitch,
                        onChanged: (value) async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState((){
                            if(prefs.getBool(keyNotifyAssignment)!) {
                              prefs.setBool(keyNotifyAssignmentBefore3Day, value);
                              NotifyAssignment3daysSwitch=prefs.getBool(keyNotifyAssignmentBefore3Day)!;
                            }
                          });
                        }
                    ),
                    SwitchListTile(
                        title: Text("5일 전"),
                        value: NotifyAssignment5daysSwitch,
                        onChanged: (value) async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState((){
                              if(prefs.getBool(keyNotifyAssignment)!) {
                                prefs.setBool(keyNotifyAssignmentBefore5Day, value);
                                NotifyAssignment5daysSwitch=prefs.getBool(keyNotifyAssignmentBefore5Day)!;
                            }
                          });
                        }
                    ),
                  ],
                ),

                SwitchListTile(
                    title: Text("동영상 알림"),
                    subtitle: Text("동영상  미시청 알림을 받습니다."),
                    value: NotifyVideo,
                    onChanged: (value) async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState((){
                        prefs.setBool(keyNotifyVideo, value);
                        NotifyVideo=prefs.getBool(keyNotifyVideo)!;
                        if(value==false){
                          prefs.setBool(keyNotifyVideoBefore6Hours, false);
                          NotifyVideo6Hours=prefs.getBool(keyNotifyVideoBefore6Hours)!;
                          prefs.setBool(keyNotifyVideoBefore1Day, false);
                          NotifyVideo1day=prefs.getBool(keyNotifyVideoBefore1Day)!;
                          prefs.setBool(keyNotifyVideoBefore3Days, false);
                          NotifyVideo3days=prefs.getBool(keyNotifyVideoBefore3Days)!;
                          prefs.setBool(keyNotifyVideoBefore5Days, false);
                          NotifyVideo5days=prefs.getBool(keyNotifyVideoBefore5Days)!;
                        }
                      });
                    }
                ),
                ExpansionTile(
                  title: Text("알림주기"),
                  children: [
                    SwitchListTile(
                        title: Text("6시간 전"),
                        value: NotifyVideo6Hours,
                        onChanged: (value) async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState((){
                            if(prefs.getBool(keyNotifyVideo)!){
                              prefs.setBool(keyNotifyVideoBefore6Hours, value);
                              NotifyVideo6Hours=prefs.getBool(keyNotifyVideoBefore6Hours)!;
                            }
                          });
                        }
                    ),
                    SwitchListTile(
                        title: Text("1일 전"),
                        value: NotifyVideo1day,
                        onChanged: (value) async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState((){
                            if(prefs.getBool(keyNotifyVideo)!){
                              prefs.setBool(keyNotifyVideoBefore1Day, value);
                              NotifyVideo1day=prefs.getBool(keyNotifyVideoBefore1Day)!;
                            }
                          });
                        }
                    ),
                    SwitchListTile(
                        title: Text("3일 전"),
                        value: NotifyVideo3days,
                        onChanged: (value) async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState((){
                            if(prefs.getBool(keyNotifyVideo)!){
                              prefs.setBool(keyNotifyVideoBefore3Days, value);
                              NotifyVideo3days=prefs.getBool(keyNotifyVideoBefore3Days)!;
                            }
                          });
                        }
                    ),
                    SwitchListTile(
                        title: Text("5일 전"),
                        value: NotifyVideo5days,
                        onChanged: (value) async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState((){
                            if(prefs.getBool(keyNotifyVideo)!){
                              prefs.setBool(keyNotifyVideoBefore5Days, value);
                              NotifyVideo5days=prefs.getBool(keyNotifyVideoBefore5Days)!;
                            }
                          });
                        }
                    ),
                  ],
                ),
              ],
            ),
          ),

          Text("사용자",style: TextStyle(fontSize: 30)),
          Padding(
            padding:EdgeInsets.all(10),
            child: Row(
              children: [
                ElevatedButton(
                  child: Text("로그아웃"),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove(keyUserId);
                    prefs.remove(keyUserPw);
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
