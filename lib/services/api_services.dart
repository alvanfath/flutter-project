import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import '../constants.dart';

class ApiServices {
  Future<http.Response> registerUser(
      String name, String email, String password) {
    final url = '${baseUrl2}register';
    final headers = <String, String>{'Content-Type': 'application/json'};
    final body =
        jsonEncode({'name': name, 'email': email, 'password': password});
    return http.post(Uri.parse(url), headers: headers, body: body);
  }

  Future<http.Response> login(String email, String password) async {
    final url = '${baseUrl2}login';
    final response = await http.post(
      Uri.parse(url),
      body: {'email': email, 'password': password},
    );

    return response;
  }

  Future<void> saveToken(String token, DateTime expirationDate) async {
    final storage = FlutterSecureStorage();
    await storage.write(
      key: 'jwt',
      value: 'bearer $token',
    );
    await storage.write(
      key: 'expired_at',
      value: expirationDate.toIso8601String(),
    );
  }

  Future<Map<String, String?>> getToken() async {
    final storage = FlutterSecureStorage();
    final json = {
      "token": await storage.read(key: 'jwt'),
      "expired_at": await storage.read(key: 'expired_at')
    };
    return json;
  }

  Future<http.Response> profile() async {
    String url = '${baseUrl}profile';
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': token.toString()
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<http.Response> logout() async {
    String url = '${baseUrl}logout';
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': token.toString()
    };
    final response = await http.post(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      await storage.deleteAll();
    }
    return response;
  }

  Future<http.Response> updateProfile(String name, String email) async {
    String url = '${baseUrl}update-profile';
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt');
    final headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token.toString()
    };
    final body = <String, String>{'name': name, 'email': email};
    final response =
        await http.put(Uri.parse(url), headers: headers, body: body);
    
    return response;
  }
}
