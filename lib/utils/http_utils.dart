import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart' as get_x;
import 'package:get_storage/get_storage.dart';

import '../config/config.dart';
import 'app_logger.dart';
import 'app_snackbar.dart';

class HttpUtils {
  static final HttpUtils _instance = HttpUtils._internal();
  factory HttpUtils() => _instance;

  late Dio _dio;
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _pendingRequests = [];
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  static final get_x.RxBool isOffline = false.obs;

  HttpUtils._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: Config.BASE_URL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = GetStorage().read('token');
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _hideGlobalNetworkError();
        return handler.next(response);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401 && !_isRefreshing) {
          _isRefreshing = true;
          try {
            final userViewModel = get_x.Get.find();
            final newToken = await userViewModel.performGuestLoginForced();
            if (newToken != null) {
              options.headers['Authorization'] = 'Bearer $newToken';
              final resp = await _dio.fetch(e.requestOptions);
              handler.resolve(resp);
            }
          } finally {
            _isRefreshing = false;
            _pendingRequests.clear();
          }
          return;
        }
        _handleError(e);
        return handler.next(e);
      },
    ));

    _initNetworkMonitor();
  }

  void _initNetworkMonitor() {
    final connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) _hideGlobalNetworkError();
      else _showGlobalNetworkError();
    });
  }

  void _showGlobalNetworkError() => isOffline.value = true;
  void _hideGlobalNetworkError() => isOffline.value = false;

  void _handleError(DioException e) {
    AppSnackbar.always('Error', e.message ?? 'Network error');
    AppLogger.e('Http Error: ${e.message}');
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    return _dio.get(path, queryParameters: queryParameters) as Future<Response<T>>;
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) async {
    return _dio.post(path, data: data) as Future<Response<T>>;
  }

  Future<Response<T>> put<T>(String path, {dynamic data}) async {
    return _dio.put(path, data: data) as Future<Response<T>>;
  }

  Future<Response<T>> delete<T>(String path, {dynamic data}) async {
    return _dio.delete(path, data: data) as Future<Response<T>>;
  }
}