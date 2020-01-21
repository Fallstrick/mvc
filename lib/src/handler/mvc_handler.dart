import 'package:fallstrick_hosting/fallstrick_hosting.dart';
import 'package:fallstrick_mvc/fallstrick_mvc.dart';
import 'package:fallstrick_mvc/src/controller/mvc_controller.dart';

class MVCHandler {
  final HttpContext _context;

  MVCHandler(this._context);

  void init() {
    var _controllers = MVCReflection.getControllers();
    var _requestControllers =
        _controllers.where((controller) => _getController(controller)).toList();
    if (_requestControllers.length > 1) {
      _context.response
        ..statusCode = HttpStatus.internalServerError
        ..writeAsync('Duplicate Routes!');
    } else if (_requestControllers.length == 1) {
      MVCController _controller = _requestControllers[0];
      var _requestUrls = _controller.getUrlList();
      if (_requestUrls.length > 1) {
        _context.response
          ..statusCode = HttpStatus.internalServerError
          ..writeAsync('Duplicate Routes!');
      } else if (_requestUrls.length == 1) {
        var _requestUrl = _requestUrls[0];
        if (_requestUrl['method'].toString().toLowerCase() ==
            _context.request.method.toLowerCase()) {
          _controller.invoke(_context.request.url.toString(),
              _context.request.method, _context);
        } else {
          _context.response
            ..statusCode = HttpStatus.methodNotAllowed
            ..writeAsync(
                'Sorry! The ${_context.request.method.toLowerCase()} request method is not supported');
        }
      }
    } else {
      _context.response
        ..statusCode = HttpStatus.notFound
        ..writeAsync('NOT Found!');
    }
  }

  bool _getController(MVCController controller) {
    var _requestUrls = controller.getUrlList();
    var urls = _requestUrls
        .where((url) => url['path'] == _context.request.url.toString())
        .toList();
    return urls.length > 0;
  }
}
