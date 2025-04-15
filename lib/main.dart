import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'core/services/auth_service.dart';

import 'app/routes/app_pages.dart';

void main() async {
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
