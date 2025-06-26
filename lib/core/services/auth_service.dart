import 'dart:convert';
import 'package:chat_app/app/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  String? token;
  String? userId;
  String? userName;
  SharedPreferences? _prefs;

  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance();
    token = _prefs!.getString('token');
    userId = _prefs!.getString('userId');
    userName = _prefs!.getString('userName');
    return this;
  }

  bool _isValid(String? input) {
    return (input != null && input != '');
  }

  bool checkAuth() {
    return (_isValid(token) && _isValid(userId) && _isValid(userName));
  }

  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://$LOCAL_URL:5000/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 400) {
      Get.snackbar(
        "Registration failed",
        json.decode(response.body)['message'],
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } else {
      Get.snackbar(
        "Registration failed",
        "Something went wrong",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://$LOCAL_URL:5000/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = jsonDecode(response.body);
      token = data['token'];
      userId = data['user']['_id'];
      userName = data['user']['username'];
      if (token != null) prefs.setString('token', token!);
      if (userId != null) prefs.setString('userId', userId!);
      if (userName != null) prefs.setString('userName', userName!);
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
    _prefs!.clear();
  }
}
