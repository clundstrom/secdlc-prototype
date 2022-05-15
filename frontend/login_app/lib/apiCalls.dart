import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiCalls {
  Future<String> addItem(
      String name, int quantity, int type, String description) async {
    Map data = {
      "name": name,
      "quantity": quantity,
      "type": type,
      "description": description
    };
    var body = json.encode(data);

    final response = await http.post(
      Uri.parse('http://localhost:2022/addItem'),
      body: body,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<int> removeItem(String name) async {
    Map data = {
      "name": name,
    };

    var body = json.encode(data);
    final response = await http.post(
      Uri.parse('http://localhost:2022/removeItem'),
      body: body,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      //throw Exception('Unexpected error occured!');
      return -1;
    }
  }

  Future<int> logout() async {
    final response = await http.post(
      Uri.parse('http://localhost:2022/logout'),
    );
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
}
