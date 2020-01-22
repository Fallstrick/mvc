import 'package:fallstrick_mvc/fallstrick_mvc.dart';
import 'package:fallstrick_hosting/fallstrick_hosting.dart';

void main() {
  createWebHostBuilder('localhost', 8080).build().run();
  MVCReflection.doScan();
}

WebHostBuilder createWebHostBuilder(String address, int port) {
  return WebHostBuilder().useHttpListener(address, port).configure((app) {
    app.use(fallStrickMVC);
  });
}

@controller
class HelloController {
  void helloWorld() {
     print('helloworld')
  }
}
