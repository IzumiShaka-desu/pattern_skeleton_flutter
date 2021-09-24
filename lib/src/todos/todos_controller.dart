class TodosController {
  TodosController._internal();
  static final _singleton = TodosController._internal();
  factory TodosController() {
    return _singleton;
  }
}
