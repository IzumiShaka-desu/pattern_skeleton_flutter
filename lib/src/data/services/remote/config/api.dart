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
  );

  Dio get dioClient => _dio;
}
