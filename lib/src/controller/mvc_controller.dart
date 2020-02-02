import 'dart:mirrors';
import 'package:fallstrick_hosting/fallstrick_hosting.dart';
import 'dart:io' as io;

/// Class include controller instance and request info;
class MVCController {
  /// method in controller instance
  final Map<String, Symbol> _urlToMethod;

  /// controller instance
  final InstanceMirror instanceMirror;

  /// request info
  final List<Map<String, String>> _urlList;

  /// response headers
  final Map<String, Map<String, String>> _urlToResponseHeader;

  final Map<String, io.ContentType> _contentTypes = {
    'text': io.ContentType.text,
    'html': io.ContentType.html,
    'json': io.ContentType.json,
    'binary': io.ContentType.binary
  };

  MVCController(this.instanceMirror, this._urlToMethod, this._urlList,
      this._urlToResponseHeader);

  ///  to call method in controller instance
  void invoke(String url, String method, HttpContext context) {
    if (_urlToMethod.containsKey('$url#$method')) {
      var result = instanceMirror
          .invoke(_urlToMethod['$url#$method'], [context]).reflectee;
      var contentType;
      if (_urlToResponseHeader.containsKey('$url#$method') &&
          _urlToResponseHeader['$url#$method'] != null) {
        var _responseHeader = _urlToResponseHeader['$url#$method'];
        var _contentType = _responseHeader['ContentType'];
        if (_contentType != null && _contentTypes[_contentType] != null) {
          contentType = _contentTypes[_contentType];
        }
      }
      if (contentType!=null) {
        context.response.headers.contentType = contentType;
      }
      context.response
        ..statusCode = HttpStatus.ok
        ..writeAsync(result);
    } else {
      context.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..writeAsync('Method Not Allowed!');
    }
  }

  /// get request info
  List<Map<String, String>> getUrlList() => _urlList;
}
