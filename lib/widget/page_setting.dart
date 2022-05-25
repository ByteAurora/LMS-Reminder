import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lms_reminder/sharedpreferences_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageSetting extends StatefulWidget {
  const PageSetting({Key? key}) : super(key: key);

  @override
  State<PageSetting> createState() => _PageSettingState();
}

class _PageSettingState extends State<PageSetting> {
  String? version = "1.0.0";
  bool notifyFinishedActivities = false;
  bool notifyAssignmentSwitch = false;
  bool notifyAssignment6HourSwitch = false;
  bool notifyAssignment1daySwitch = false;
  bool notifyAssignment3daysSwitch = false;
  bool notifyAssignment5daysSwitch = false;
  bool notifyVideo = false;
  bool notifyVideo6Hours = false;
  bool notifyVideo1day = false;
  bool notifyVideo3days = false;
  bool notifyVideo5days = false;

  TextStyle categoryTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  TextStyle optionTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 14,
  );

  TextStyle optionSummaryTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 14,
  );

  @override
  void initState() {
    super.initState();
    _loadSetting();
  }

  _loadSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notifyFinishedActivities =
          (prefs.getBool(keyNotifyFinishedActivities) ?? false);
      notifyAssignmentSwitch = (prefs.getBool(keyNotifyAssignment) ?? false);
      notifyAssignment6HourSwitch =
          (prefs.getBool(keyNotifyAssignmentBefore6Hours) ?? false);
      notifyAssignment1daySwitch =
          (prefs.getBool(keyNotifyAssignmentBefore1Day) ?? false);
      notifyAssignment3daysSwitch =
          (prefs.getBool(keyNotifyVideoBefore3Days) ?? false);
      notifyAssignment5daysSwitch =
          (prefs.getBool(keyNotifyVideoBefore5Days) ?? false);
      notifyVideo = (prefs.getBool(keyNotifyVideo) ?? false);
      notifyVideo6Hours = (prefs.getBool(keyNotifyVideoBefore6Hours) ?? false);
      notifyVideo1day = (prefs.getBool(keyNotifyVideoBefore1Day) ?? false);
      notifyVideo3days = (prefs.getBool(keyNotifyVideoBefore3Days) ?? false);
      notifyVideo5days = (prefs.getBool(keyNotifyVideoBefore5Days) ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('설정'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Text("일반", style: categoryTextStyle),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Icon(Icons.info),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16, left: 8),
                  child: Text(
                    "버전 : " + version!,
                    style: optionTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 8.0),
            child: Text("알림", style: categoryTextStyle),
          ),
          Column(
            children: <Widget>[
              SwitchListTile(
                  title: Text(
                    "완료한 활동 알림",
                    style: optionTextStyle,
                  ),
                  subtitle: Text(
                    "완료한 활동의 알림을 받습니다",
                    style: optionSummaryTextStyle,
                  ),
                  value: notifyFinishedActivities,
                  onChanged: (value) async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      prefs.setBool(keyNotifyFinishedActivities, value);
                      notifyFinishedActivities =
                          prefs.getBool(keyNotifyFinishedActivities)!;
                    });
                  }),
              Divider(thickness: 1, height: 0.5, color: Colors.grey.shade300),
              SwitchListTile(
                  title: Text(
                    "과제 알림",
                    style: optionTextStyle,
                  ),
                  subtitle: Text(
                    "과제 알람을 받습니다",
                    style: optionSummaryTextStyle,
                  ),
                  value: notifyAssignmentSwitch,
                  onChanged: (value) async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      prefs.setBool(keyNotifyAssignment, value);
                      notifyAssignmentSwitch =
                          prefs.getBool(keyNotifyAssignment)!;
                      if (value == false) {
                        prefs.setBool(keyNotifyAssignmentBefore6Hours, false);
                        notifyAssignment6HourSwitch =
                            prefs.getBool(keyNotifyAssignmentBefore6Hours)!;
                        prefs.setBool(keyNotifyAssignmentBefore1Day, false);
                        notifyAssignment1daySwitch =
                            prefs.getBool(keyNotifyAssignmentBefore1Day)!;
                        prefs.setBool(keyNotifyAssignmentBefore3Days, false);
                        notifyAssignment3daysSwitch =
                            prefs.getBool(keyNotifyAssignmentBefore3Days)!;
                        prefs.setBool(keyNotifyAssignmentBefore5Days, false);
                        notifyAssignment5daysSwitch =
                            prefs.getBool(keyNotifyAssignmentBefore5Days)!;
                      }
                    });
                  }),
              Divider(thickness: 1, height: 0.5, color: Colors.grey.shade300),
              ExpansionTile(
                title: Text(
                  "과제 알림주기",
                  style: optionTextStyle,
                ),
                children: [
                  SwitchListTile(
                      title: Text(
                        "6시간 전",
                        style: optionTextStyle,
                      ),
                      value: notifyAssignment6HourSwitch,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyAssignment)!) {
                            prefs.setBool(
                                keyNotifyAssignmentBefore6Hours, value);
                            notifyAssignment6HourSwitch =
                                prefs.getBool(keyNotifyAssignmentBefore6Hours)!;
                          }
                        });
                      }),
                  SwitchListTile(
                      title: Text(
                        "1일 전",
                        style: optionTextStyle,
                      ),
                      value: notifyAssignment1daySwitch,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyAssignment)!) {
                            prefs.setBool(keyNotifyAssignmentBefore1Day, value);
                            notifyAssignment1daySwitch =
                                prefs.getBool(keyNotifyAssignmentBefore1Day)!;
                          }
                        });
                      }),
                  SwitchListTile(
                      title: Text(
                        "3일 전",
                        style: optionTextStyle,
                      ),
                      value: notifyAssignment3daysSwitch,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyAssignment)!) {
                            prefs.setBool(
                                keyNotifyAssignmentBefore3Days, value);
                            notifyAssignment3daysSwitch =
                                prefs.getBool(keyNotifyAssignmentBefore3Days)!;
                          }
                        });
                      }),
                  SwitchListTile(
                      title: Text(
                        "5일 전",
                        style: optionTextStyle,
                      ),
                      value: notifyAssignment5daysSwitch,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyAssignment)!) {
                            prefs.setBool(
                                keyNotifyAssignmentBefore5Days, value);
                            notifyAssignment5daysSwitch =
                                prefs.getBool(keyNotifyAssignmentBefore5Days)!;
                          }
                        });
                      }),
                ],
              ),
              Divider(thickness: 1, height: 0.5, color: Colors.grey.shade300),
              SwitchListTile(
                  title: Text(
                    "동영상 알림",
                    style: optionTextStyle,
                  ),
                  subtitle: Text(
                    "동영상 알림을 받습니다.",
                    style: optionSummaryTextStyle,
                  ),
                  value: notifyVideo,
                  onChanged: (value) async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      prefs.setBool(keyNotifyVideo, value);
                      notifyVideo = prefs.getBool(keyNotifyVideo)!;
                      if (value == false) {
                        prefs.setBool(keyNotifyVideoBefore6Hours, false);
                        notifyVideo6Hours =
                            prefs.getBool(keyNotifyVideoBefore6Hours)!;
                        prefs.setBool(keyNotifyVideoBefore1Day, false);
                        notifyVideo1day =
                            prefs.getBool(keyNotifyVideoBefore1Day)!;
                        prefs.setBool(keyNotifyVideoBefore3Days, false);
                        notifyVideo3days =
                            prefs.getBool(keyNotifyVideoBefore3Days)!;
                        prefs.setBool(keyNotifyVideoBefore5Days, false);
                        notifyVideo5days =
                            prefs.getBool(keyNotifyVideoBefore5Days)!;
                      }
                    });
                  }),
              Divider(thickness: 1, height: 0.5, color: Colors.grey.shade300),
              ExpansionTile(
                title: Text(
                  "동영상 알림주기",
                  style: optionTextStyle,
                ),
                children: [
                  SwitchListTile(
                      title: Text(
                        "6시간 전",
                        style: optionTextStyle,
                      ),
                      value: notifyVideo6Hours,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyVideo)!) {
                            prefs.setBool(keyNotifyVideoBefore6Hours, value);
                            notifyVideo6Hours =
                                prefs.getBool(keyNotifyVideoBefore6Hours)!;
                          }
                        });
                      }),
                  SwitchListTile(
                      title: Text(
                        "1일 전",
                        style: optionTextStyle,
                      ),
                      value: notifyVideo1day,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyVideo)!) {
                            prefs.setBool(keyNotifyVideoBefore1Day, value);
                            notifyVideo1day =
                                prefs.getBool(keyNotifyVideoBefore1Day)!;
                          }
                        });
                      }),
                  SwitchListTile(
                      title: Text(
                        "3일 전",
                        style: optionTextStyle,
                      ),
                      value: notifyVideo3days,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyVideo)!) {
                            prefs.setBool(keyNotifyVideoBefore3Days, value);
                            notifyVideo3days =
                                prefs.getBool(keyNotifyVideoBefore3Days)!;
                          }
                        });
                      }),
                  SwitchListTile(
                      title: Text(
                        "5일 전",
                        style: optionTextStyle,
                      ),
                      value: notifyVideo5days,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyVideo)!) {
                            prefs.setBool(keyNotifyVideoBefore5Days, value);
                            notifyVideo5days =
                                prefs.getBool(keyNotifyVideoBefore5Days)!;
                          }
                        });
                      }),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 24.0,
              bottom: 8.0,
            ),
            child: Text("사용자", style: categoryTextStyle),
          ),
          InkWell(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('로그아웃'),
                      content: Text('정말로 로그아웃 하시겠습니까?'),
                      actions: [
                        ElevatedButton(
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.remove(keyUserId);
                              prefs.remove(keyUserPw);

                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/login', (route) => false);
                            },
                            child: Text('로그아웃')),
                        ElevatedButton(onPressed: () {}, child: Text('취소')),
                      ],
                    );
                  });
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
                  child: Text(
                    "로그아웃",
                    style: optionTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
