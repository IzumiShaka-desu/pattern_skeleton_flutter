import 'package:dio/dio.dart';
import 'package:skeleton_test/src/data/model/todos.dart';

import 'remote/config/api.dart';

class TodosService {
  TodosService._internal();
  static final _singleton = TodosService._internal();
  factory TodosService() => _singleton;

  final Dio _client = Api().dioClient;
  static const path = '/todos';
  Future<List<Todos>> getTodos({int from = 0, int? limit}) async {
    var params = <String, dynamic>{};
    params['_start'] = from;
    if (limit != null) {
      params['_limit'] = limit;
    }
    var res = await _client.get(path, queryParameters: params);
    if (res.statusCode == 200) {
      if (res.data != null) {
        var result = (res.data as List);
        return result
            .map<Todos>(
              (e) => Todos.fromJson(e),
            )
            .toList();
      }
    }
    throw Exception('network error');
  }
}
