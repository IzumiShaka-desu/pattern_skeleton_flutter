class Api {
  Api._internal();
  static final _singleton = Api._internal();
  factory Api() => _singleton;
}
