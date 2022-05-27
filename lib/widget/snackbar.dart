import 'package:flutter/material.dart';

/// SnackBar를 표시하는 함수.
void showSnackBar(BuildContext context, String text, int second,
    {String? actionText, Function()? onPressed}) {
  // 보여지고 있는 SnackBar가 있을 경우 숨긴 후 새로운 SnackBar 표시.
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(text),
        duration: Duration(seconds: second),
        action: (actionText != null && onPressed != null)
            ? SnackBarAction(
                label: actionText,
                onPressed: onPressed,
              )
            : null),
  );
}
