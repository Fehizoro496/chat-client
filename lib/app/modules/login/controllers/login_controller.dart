import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/services/socket_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  bool isLoading = false;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    update();

    final success = await authService.login(email, password);

    isLoading = false;
    update();
    return success;
  }

  void initSocket() async {
    await Get.putAsync(() => SocketService().init());
  }
}

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