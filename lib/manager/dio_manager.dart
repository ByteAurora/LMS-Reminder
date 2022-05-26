import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Http 통신을 담당하는 클래스.
class DioManager {
  /// Singleton Pattern 구현을 위한 객체.
  static final DioManager _instance = DioManager._constructor();

  DioManager._constructor();

  factory DioManager() {
    return _instance;
  }

  /// 재사용되는 Dio 객체.
  Dio? dio;

  /// 재사용할 cookie 값.
  String? cookie;

  /// DioManager 초기화.
  void init(BaseOptions options) {
    // dio 객체가 null일 경우 새로운 Dio 객체 생성.
    dio ??= Dio();

    // 매개변수로 전달된 기본 옵션을 dio 객체에 할당.
    dio!.options = options;
  }

  /// http post 요청을 전송하는 함수.
  Future<Response> httpPost(
      Options options, String subUrl, Map<String, String> data) async {
    // Dio 객체가 null일 경우 Exception 발생.
    if (dio == null) {
      throw Exception(
          'Dio object is not initialized. Use DioManager.init() to initialize dio object.');
    }

    return await dio!.post(subUrl, data: data, options: options);
  }

  /// http get 요청을 전송하는 함수.
  Future<Response> httpGet(
      {required Options options,
      bool useExistCookie = false,
      required String subUrl}) async {
    // Dio 객체가 null일 경우 Exception 발생.
    if (dio == null) {
      throw Exception(
          'Dio object is not initialized. Use DioManager.init() to initialize dio object.');
    }

    if (useExistCookie && cookie != null) {
      // 이미 존재하는 cookie를 사용하면서 해당 cookie가 null이 아닐 경우 header에 해당 cookie 추가.
      options.headers ??= <String, String>{};
      options.headers!['cookie'] = cookie;
    }

    return await dio!.get(subUrl, options: options);
  }

  /// 전달된 url로부터 파일을 다운로드하는 함수.
  Future downloadFileFromUrl(String url, File file, VoidCallback ifDownloadSuccessful,
      VoidCallback ifDownloadFails) async {
    try {
      Response response = await DioManager().httpGet(
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
        useExistCookie: true,
        subUrl: url,
      );

      var randomAccessFile = file.openSync(mode: FileMode.write);
      randomAccessFile.writeFromSync(response.data);
      await randomAccessFile.close();

      if (await file.exists()) {
        ifDownloadSuccessful.call();
      } else {
        ifDownloadFails.call();
      }
    } catch (e) {
      print(e);
      ifDownloadFails.call();
    }
  }
}
