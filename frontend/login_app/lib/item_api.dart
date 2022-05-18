import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class ItemApi {
  static Future getItems() {
    return http.get(
      Uri.parse('http://localhost:2022/getInventory'),
      //headers: {HttpHeaders.contentTypeHeader: 'application/json',},
    );
  }
}
