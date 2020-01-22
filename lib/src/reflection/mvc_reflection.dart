import 'dart:mirrors';

import 'package:fallstrick_mvc/src/controller/mvc_controller.dart';

/// [MVCReflection] get annotation from Controller class
class MVCReflection {
  static final List<MVCController> _controllers = [];
  static final List<String> _requestAnnotation = [
    'requestmapping',
    'get',
    'post',
    'delete',
    'put'
  ];

  /// scan annotations then get controller annotation and route annotation
  static void doScan() {
    currentMirrorSystem().libraries.values.forEach((lib) {
      lib.declarations.values.forEach((declaration) {
        var metadataLst = declaration.metadata;
        if (metadataLst.toString().toLowerCase().contains('controller')) {
          ClassMirror mirror = declaration;
          // ignore: omit_local_variable_types
          Map<String,Symbol>  _urlToMethod = {};
          // ignore: omit_local_variable_types
          List<Map<String, String>> _urlList = [];
          var _controllerRequestPath = '';
          var _controllerRequestMappings = mirror.metadata
              .where((item) =>
                  item.reflectee.toString().toLowerCase() == 'requestmapping')
              .toList();
          if (_controllerRequestMappings.length > 1) {
            throw Exception(
                'RequetMapping annotation is more than one for the class ${mirror.reflectedType.toString()}');
          } else if (_controllerRequestMappings.length == 1) {
            var _controllerRequestMapping = _controllerRequestMappings[0];
            _controllerRequestPath = _controllerRequestMapping.reflectee.path;
          }

          mirror.declarations.forEach((symbol, declarationMirror) {
            if (symbol.toString() != mirror.simpleName.toString()) {
              MethodMirror mirror = declarationMirror;
              var _methodRequestMappings = [];
              declarationMirror.metadata.forEach((metadata) {
                if (_requestAnnotation.contains(
                    metadata.reflectee.runtimeType.toString().toLowerCase())) {
                  _methodRequestMappings.add(metadata);
                }
              });
              if (_methodRequestMappings.length > 1) {
                throw Exception(
                    'RequetMapping annotation is more than one for the method ${mirror.toString()}');
              } else if (_methodRequestMappings.length == 1) {
                var _methodRequestMapping = _methodRequestMappings[0];
                var _requestPath = _controllerRequestPath +
                    _methodRequestMapping.reflectee.path;
                String _requestMethod = _methodRequestMapping.reflectee.method;
                var _url = {'path': _requestPath, 'method': _requestMethod};
                _urlList.add(_url);
                _urlToMethod.putIfAbsent(
                    '$_requestPath#$_requestMethod', () => symbol);
              }
            }
          });
          var im = mirror.newInstance(Symbol.empty, []);
          var mvcController = MVCController(im, _urlToMethod, _urlList);
          _controllers.add(mvcController);
        }
      });
    });
  }

  static List getControllers() => _controllers;
}
