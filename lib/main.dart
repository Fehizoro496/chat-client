import 'package:chat_app/core/services/notification_service.dart';
import 'package:chat_app/core/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart'; // Add this import
import 'dart:io'; // Import for platform check

import 'core/services/auth_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    // Apply only for Windows
    await windowManager.ensureInitialized(); // Initialize window manager

    WindowOptions windowOptions = const WindowOptions(
      size: Size(375, 667), // Phone-like size
      // center: true,
      minimumSize: Size(375, 667), // Lock minimum size
      maximumSize: Size(375, 667), // Lock maximum size
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => NotificationService().init());
  await Get.putAsync(() => SocketService().init());
  final AuthService authService = Get.find<AuthService>();

  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      initialRoute: authService.checkAuth() ? Routes.HOME : Routes.LOGIN,
      getPages: AppPages.routes,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          primaryColor: Colors.blue,
          useMaterial3: true),
    ),
  );
}
