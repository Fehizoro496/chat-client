import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthService extends GetxService {
  String? token;
  String? userId;
  String? userName;

  Future<AuthService> init() async => this;

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data['token'];
      userId = data['user']['_id'];
      userName = data['user']['username'];
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    token = null;
    userId = null;
    userName = null;
  }
}
