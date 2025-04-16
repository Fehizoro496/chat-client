import 'dart:convert';

import 'package:chat_app/app/models/discussion_model.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/app/models/message_model.dart';

class DiscussionController extends GetxController {
  //TODO: Implement DiscussionController
  Discussion discussion = Get.arguments['discussion'];
  final AuthService authService = Get.find<AuthService>();
  List<Message> messages = [];
  TextEditingController inputController = TextEditingController();
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
  }

  String getName() {
    if (discussion.isGroupChat) {
      return discussion.name ?? 'still unnamed';
    }
    String temp = discussion.participantIds
        .where((element) => element != authService.userId)
        .first;
    return temp;
  }

  Future<void> fetchMessages() async {
    isLoading = true;
    update();

    final token = authService.token;

    final response = await http.get(
      Uri.parse("http://localhost:5000/api/chats/messages/${discussion.id}"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      messages = data.map((e) {
        return Message.fromJson(e);
      }).toList();
    }
    update();

    isLoading = false;
  }
}
