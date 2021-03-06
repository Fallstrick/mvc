import 'package:fallstrick_hosting/fallstrick_hosting.dart';
import 'package:fallstrick_mvc/fallstrick_mvc.dart';
import 'package:fallstrick_mvc/src/controller/mvc_controller.dart';

/// handler route
class MVCHandler {
  final HttpContext _context;

  MVCHandler(this._context);

  /// middleware init method
  void init() {
    var _controllers = MVCReflection.getControllers();
    var _requestControllers =
        _controllers.where((controller) => _getController(controller)).toList();
    if (_requestControllers.length > 1) {
      _duplicateRoutes();
    } else if (_requestControllers.length == 1) {
      _handleController(_requestControllers);
    } else {
      _notFound();
    }
  }

  /// handler controller
  void _handleController(List _requestControllers) {
    MVCController _controller = _requestControllers[0];
    var _requestUrls = _controller.getUrlList();
    var _method = _context.request.method;
    var _url = _context.request.url.toString();
    _requestUrls = _requestUrls
        .where((url) => url['path'] == _url && url['method'] == _method)
        .toList();
    if (_requestUrls.isNotEmpty) {
      _controller.invoke(_url, _method, _context);
    } else {
      _methodNotAllowed();
    }
  }

  /// jude controller which contains request url
  bool _getController(MVCController controller) {
    var _requestUrls = controller.getUrlList();
    var urls = _requestUrls
        .where((url) => url['path'] == _context.request.url.toString())
        .toList();
    return urls.isNotEmpty;
  }

  /// response return  'not found'
  void _notFound() {
    _context.response
      ..statusCode = HttpStatus.notFound
      ..writeAsync('NOT Found!');
  }

  /// response return  'method not allowed'
  void _methodNotAllowed() {
    _context.response
      ..statusCode = HttpStatus.methodNotAllowed
      ..writeAsync(
          'Sorry! The ${_context.request.method.toLowerCase()} request method is not supported');
  }

  /// response return  'duplicate routes'
  void _duplicateRoutes() {
    _context.response
      ..statusCode = HttpStatus.internalServerError
      ..writeAsync('Duplicate Routes!');
  }
}
