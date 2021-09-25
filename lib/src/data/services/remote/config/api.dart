import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

class Api {
  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  final _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASEURL']!,
      receiveTimeout: 3000,
      sendTimeout: 5000,
    ),
  )..interceptors.add(InterceptorsWrapper(onError: (error, handler) {
      if (error.error is SocketException) {
        throw ('network error');
      }
      return handler.next(error);
    }));

  Dio get dioClient => _dio;
}
