import 'dart:convert';
import 'package:chat_app/app/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthService extends GetxService {
  String? token;
  String? userId;
  String? userName;

  Future<AuthService> init() async => this;

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://$LOCAL_URL:5000/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data['token'];
      userId = data['user']['_id'];
      userName = data['user']['username'];
      return true;
    } else if (response.statusCode == 404) {
      Get.snackbar(
        "Login Failed",
        "User not found",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } else if (response.statusCode == 400) {
      Get.snackbar(
        "Login Failed",
        "Wrong password",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } else {
      Get.snackbar(
        "Login Failed",
        "Something went wrong",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
  }

  void logout() {
    token = null;
    userId = null;
    userName = null;
  }
}
