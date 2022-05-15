import 'package:dio/dio.dart';

class DioManager {
  static final DioManager _instance = DioManager._constructor();
  Dio? dio;
  String? cookie;

  DioManager._constructor();

  factory DioManager() {
    return _instance;
  }

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
}
