import 'package:dio/dio.dart';

import '../../core/config/env_config.dart';

class ApiClient {
  ApiClient(EnvConfig config)
    : _dio = Dio(
        BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

  final Dio _dio;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
    );
    return _unwrapResponse(response.data);
  }

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return _unwrapResponse(response.data);
  }

  dynamic _unwrapResponse(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      if (payload.containsKey('data')) {
        return payload['data'];
      }
      if (payload.containsKey('result')) {
        return payload['result'];
      }
    }
    return payload;
  }
}
