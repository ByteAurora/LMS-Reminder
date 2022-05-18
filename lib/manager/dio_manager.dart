import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Http 통신을 담당하는 클래스.
class DioManager {
  /// Singleton Pattern 구현을 위한 객체.
  static final DioManager _instance = DioManager._constructor();
  Dio? dio;
  String? cookie;

  DioManager._constructor();

  factory DioManager() {
    return _instance;
  }

  /// DioManager 초기화.
  void init(BaseOptions options) {
    dio ??= Dio();

    dio!.options = options;
  }

  /// http post 요청을 전송하는 함수.
  Future<Response> httpPost(
      Options options, String subUrl, Map<String, String> data) async {
    if (dio == null) {
      throw Exception(
          'Dio object is not initialized. Use HttpManager.init() to initializer dio object.');
    }

    return await dio!.post(subUrl, data: data, options: options);
  }

  /// http get 요청을 전송하는 함수.
  Future<Response> httpGet(
      {required Options options,
      bool useExistCookie = false,
      required String subUrl}) async {
    if (dio == null) {
      throw Exception(
          'Dio object is not initialized. Use HttpManager.init() to initializer dio object.');
    }

    if (useExistCookie && cookie != null) {
      options.headers ??= <String, String>{};
      options.headers!['cookie'] = cookie;
    }

    return await dio!.get(subUrl, options: options);
  }

  Future httpGetFile(String url, File file, VoidCallback callback) async {
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
    } catch (e) {
      print(e);
    }
    callback.call();
  }
}
