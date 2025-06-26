// import 'package:chat_app/app/modules/discussion/views/discussion_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<LoginController>(
        builder: (controller) => SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/logo_metm.png'),
                    // const Icon(Icons.person_outline,
                    //     size: 60, color: Colors.black87),
                    // const SizedBox(height: 32),
                    // const Text(
                    //   'Welcome',
                    //   style: TextStyle(
                    //     fontSize: 28,
                    //     fontWeight: FontWeight.w300,
                    //     letterSpacing: 1.5,
                    //   ),
                    // ),
                    const SizedBox(height: 48),
                    TextField(
                      controller: controller.usernameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Pseudo',
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.passwordCtrl,
                      obscureText: controller.hidePassword,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon:
                            const Icon(Icons.lock, color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black54,
                          ),
                          onPressed: () => controller.tooglePwdVisibility(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                final success = await controller.login(
                                  controller.usernameCtrl.text.trim(),
                                  controller.passwordCtrl.text.trim(),
                                );
                                if (success) {
                                  Get.offAllNamed('/home');
                                  // controller.initSocket();
                                }
                              },
                              child: const Text(
                                'Se connecter',
                                style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
