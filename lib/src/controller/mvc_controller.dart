import 'dart:mirrors';
import 'package:fallstrick_hosting/fallstrick_hosting.dart';

/// Class include controller instance and request info;
class MVCController {
  /// method in controller instance
  final Map<String, Symbol> _urlToMethod;
  /// controller instance
  final InstanceMirror instanceMirror;
  /// request info
  final List<Map<String, String>> _urlList;

  MVCController(this.instanceMirror, this._urlToMethod, this._urlList);

  ///  to call method in controller instance
  void invoke(String url, String method, HttpContext context) {
    if (_urlToMethod.containsKey('$url#$method')) {
      instanceMirror.invoke(_urlToMethod['$url#$method'], [context]);
    } else {
      context.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..writeAsync('Method Not Allowed!');
    }
  }

  /// get request info
  List<Map<String, String>> getUrlList() => _urlList;
}
