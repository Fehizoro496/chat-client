import 'package:chat_app/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController verifyPasswordCtrl = TextEditingController();

  AuthService authService = Get.find<AuthService>();

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  Future<bool> register() async {
    isLoading = true;
    update();

    final success = await authService.register(
        usernameCtrl.text, emailCtrl.text, passwordCtrl.text);

    isLoading = false;
    update();
    return success;
  }
}
