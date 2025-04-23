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
      center: true,
      minimumSize: Size(375, 667), // Lock minimum size
      maximumSize: Size(375, 667), // Lock maximum size
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await Get.putAsync(() => AuthService().init());
  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true),
    ),
  );
}
