import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  bool _isLoadingNewItem = false;

  bool get isLoadingNewItem => _isLoadingNewItem;

  void initialLoad({int retry = 0, required BuildContext context}) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      _todos = await _service.getTodos(limit: 8);
    } on SocketException catch (e) {
      debugPrint('$e');

      ///Fluttertoast.cancel();

      if ('$e'.contains('network error')) {
        _retryInitialLoad(retry, context);
      }
    } catch (e) {
      debugPrint('$e');

      ///Fluttertoast.cancel();

      if ('$e'.contains('network error')) {
        _retryInitialLoad(retry, context);
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  _retryInitialLoad(int retry, BuildContext context) {
    showToast(
      AppLocalizations.of(context)?.networkErrorMessage,
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
          '${AppLocalizations.of(context)?.retryMessage}: $retry',
        );
        initialLoad(
          retry: retry,
          context: context,
        );
      },
    );
  }

  void loadNewItem({int retry = 0, required BuildContext context}) async {
    if (_isLoadingNewItem) return;
    _isLoadingNewItem = true;
    notifyListeners();
    try {
      _todos.addAll(await _service.getTodos(from: _todos.length, limit: 8));
    } on SocketException catch (e) {
      debugPrint('$e');

      ///Fluttertoast.cancel();

      if ('$e'.contains('network error')) {
        _retryGetNewItem(retry, context);
      }
    } catch (e) {
      debugPrint('$e');

      ///Fluttertoast.cancel();

      if ('$e'.contains('network error')) {
        _retryGetNewItem(retry, context);
      }
    }
    _isLoadingNewItem = false;
    notifyListeners();
  }

  _retryGetNewItem(int retry, BuildContext context) {
    showToast(
      AppLocalizations.of(context)?.networkErrorMessage,
    );
    if (retry >= 5) {
      _isLoadingNewItem = false;
      notifyListeners();
      return;
    }
    retry++;
    Future.delayed(
      const Duration(seconds: 2),
      () {
        ///Fluttertoast.cancel();

        showToast(
          '${AppLocalizations.of(context)?.retryMessage}: $retry',
        );
        loadNewItem(
          retry: retry,
          context: context,
        );
      },
    );
  }
}

showToast(String? msg) => Fluttertoast.showToast(
      msg: '$msg',
    );
