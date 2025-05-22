import 'dart:convert';
import 'package:chat_app/app/models/discussion_model.dart';
import 'package:chat_app/core/services/notification_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/app/models/message_model.dart';
import 'package:chat_app/app/constant.dart';

class DiscussionController extends GetxController {
  Discussion discussion = Get.arguments['discussion'];
  final ScrollController scrollController = ScrollController();
  final AuthService authService = Get.find<AuthService>();
  final SocketService socketService = Get.find<SocketService>();
  final NotificationService notificationService =
      Get.find<NotificationService>();
  List<MessageModel> messages = [];
  TextEditingController inputController = TextEditingController();
  bool isLoading = true;
  bool moreActions = false;

  @override
  void onInit() async {
    super.onInit();
    await fetchMessages();
    socketService.onMessageReceived = handleIncomingMessage;
    isLoading = false;
    update();
  }

  void markAsSeen() {}

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  void toogleMoreActions() {
    moreActions = !moreActions;
    update();
  }

  void closeMoreActions() {
    moreActions = false;
    update();
  }

  void handleIncomingMessage(MessageModel data) {
    messages.add(data);
    update(); // Trigger UI refresh
  }

  Future<void> fetchMessages() async {
    final response = await http.get(
      Uri.parse("http://$LOCAL_URL:5000/api/chats/messages/${discussion.id}"),
      headers: {
        'Authorization': 'Bearer ${authService.token}',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      messages = data.map((e) {
        return MessageModel.fromJson(e);
      }).toList();
    }
  }

  void sendMessage() {
    if (inputController.text.trim().isNotEmpty) {
      socketService.sendMessage({
        'chatRoomId': discussion.id,
        'senderId': authService.userId,
        'message': inputController.text,
        'messageType': 'text'
      });
      inputController.clear();
      update();
      scrollToBottom();
    }
  }

  void showNotification() {
    notificationService.showNotification(
      title: "test title",
      body: 'test body',
    );
  }
}
