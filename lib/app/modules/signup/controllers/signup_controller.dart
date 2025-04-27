import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/services/socket_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  bool isLoading = false;
  bool hidePassword = true;

  void tooglePwdVisibility() {
    hidePassword = !hidePassword;
    update();
  }

  Future<bool> signup(String email, String username, String password) async {
    // isLoading = true;
    // update();

    // final success = await authService.signup(email, username, password);

    // isLoading = false;
    // update();
    // return success;
    return true;
  }

  // void initSocket() async {
  //   await Get.putAsync(() => SocketService().init());
  // }
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