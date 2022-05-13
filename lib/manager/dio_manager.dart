import 'package:dio/dio.dart';

class DioManager {
  Dio? dio;
  String? cookie;

  void init(BaseOptions options) {
    dio ??= Dio();

    dio!.options = options;
  }

  Future<Response> httpPost(
      Options options, String subUrl, Map<String, String> data) async {
    if (dio == null) {
      throw Exception(
          'Dio object is not initialized. Use HttpManager.init() to initializer dio object.');
    }

    return await dio!.post(subUrl, data: data, options: options);
  }

  Future<Response> httpGet(Options options, String subUrl) async {
    if (dio == null) {
      throw Exception(
          'Dio object is not initialized. Use HttpManager.init() to initializer dio object.');
    }

    return await dio!.get(subUrl, options: options);
  }
}
