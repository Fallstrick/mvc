import 'package:fallstrick_routing/fallstrick_routing.dart';
import 'package:fallstrick_mvc/fallstrick_mvc.dart';
import 'package:fallstrick_hosting/fallstrick_hosting.dart';
import 'dart:convert';

void main() {
  createWebHostBuilder('localhost', 8080).build().run();
  MVCReflection.doScan();
}

WebHostBuilder createWebHostBuilder(String address, int port) {
  return WebHostBuilder().useHttpListener(address, port).configure((app) {
    app.use(fallStrickMVC);
  });
}

@RequestMapping(path: '/hello')
@controller
class HelloController {
  @Get(path: '/helloword')
  void helloWorld(HttpContext context) {
    var map = {'code': 200, 'message': 'helloword', 'data': {}};
    context.response
      ..headers.contentType = ContentType.json
      ..statusCode = 200
      ..writeAsync(json.encode(map));
  }
}
