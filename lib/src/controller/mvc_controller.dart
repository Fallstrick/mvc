import 'dart:mirrors';
import 'package:fallstrick_hosting/fallstrick_hosting.dart';

class MVCController {
  final Map<String, Symbol> urlToMethod;
  final InstanceMirror instanceMirror;
  final List<Map<String, String>> _urlList;

  MVCController(this.instanceMirror, this.urlToMethod, this._urlList);

  void invoke(String url, String method, HttpContext context) {
    if (urlToMethod.containsKey('$url#$method')) {
      instanceMirror.invoke(urlToMethod['$url#$method'], [context]);
    } else {
      context.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..writeAsync('Method Not Allowed!');
    }
  }

  List<Map<String, String>> getUrlList() => _urlList;
}
