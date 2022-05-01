import 'package:flutter/material.dart';

/// 최상위 Stateful Widget.
class AppMainStateful extends StatefulWidget {
  const AppMainStateful({Key? key, required this.appBarTitle})
      : super(key: key);

  final String? appBarTitle;

  @override
  State<AppMainStateful> createState() => _AppMainStatefulState();
}

class _AppMainStatefulState extends State<AppMainStateful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle!),
      ),
      body: Container(),
    );
  }
}
