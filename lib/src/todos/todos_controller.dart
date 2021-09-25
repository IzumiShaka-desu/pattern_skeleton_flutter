import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeleton_test/src/app.dart';
import 'package:skeleton_test/src/data/model/todos.dart';
import 'package:skeleton_test/src/data/services/todos_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TodosController extends ChangeNotifier {
  TodosController._internal();
  static final _singleton = TodosController._internal();
  factory TodosController() => _singleton;

  final TodosService _service = TodosService();

  List<Todos> _todos = [];

  List<Todos> get todos => _todos;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void initialLoad({int retry = 0}) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      _todos = await _service.getTodos(limit: 8);
    } on SocketException catch (e) {
      debugPrint('$e');

      ///Fluttertoast.cancel();

      if ('$e'.contains('network error')) {
        _retryInitialLoad(retry);
      }
    } catch (e) {
      debugPrint('$e');

      ///Fluttertoast.cancel();

      if ('$e'.contains('network error') || '$e'.contains('SocketException')) {
        _retryInitialLoad(retry);
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  _retryInitialLoad(int retry) {
    showToast(
      AppLocalizations.of(MyApp.gkey.currentContext!)?.networkErrorMessage,
    );
    if (retry >= 5) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    retry++;
    Future.delayed(
      const Duration(seconds: 2),
      () {
        ///Fluttertoast.cancel();

        showToast(
          '${AppLocalizations.of(MyApp.gkey.currentContext!)?.retryMessage}: $retry',
        );
        initialLoad(
          retry: retry,
        );
      },
    );
  }
}

showToast(String? msg) => Fluttertoast.showToast(
    msg: "$msg",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0);
