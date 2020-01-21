import 'package:fallstrick_hosting/fallstrick_hosting.dart';
import 'package:fallstrick_mvc/src/handler/mvc_handler.dart';
RequestDelegate fallStrickMVC(RequestDelegate next) {
  return (context) {
    MVCHandler(context).init();
  };
}
