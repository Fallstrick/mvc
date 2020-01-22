# fallstrick_mvc

![language](https://woolson.gitee.io/npmer-badge/ilcr-none-none-dart-ffffff-555555-%3E=2.7.0%20%3C3.0.0-ffffff-007ec6-r-t-t.svg)
![license](https://img.shields.io/github/license/Fallstrick/hosting)

## Usage

A simple usage example:

```dart
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

@controller
class HelloController {
  void helloWorld() {
     print('helloworld')
  }
}

```
We should use this package with [fallstrick_routing][fallstrick_routing] and [fallstrick_hosting][fallstrick_hosting]

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Fallstrick/mvc/issues
[fallstrick_routing]: https://github.com/Fallstrick/routing
[fallstrick_hosting]: https://github.com/Fallstrick/hosting