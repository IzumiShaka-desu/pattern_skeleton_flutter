import 'package:dio/dio.dart';

import 'remote/config/api.dart';

class TodosService {
  TodosService._internal();
  static final _singleton = TodosService._internal();
  factory TodosService() => _singleton;

  final Dio _api = Api().dioClient;
}
