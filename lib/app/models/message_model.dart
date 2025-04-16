import 'package:chat_app/core/services/auth_service.dart';
import 'package:get/get.dart';

class Message {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String message;
  final String messageType; // 'text', 'image', 'file'
  final bool isSeen;
  final String createdAt;
  final String updatedAt;
  final AuthService authService = Get.find<AuthService>();

  Message({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.message,
    required this.messageType,
    required this.isSeen,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      chatRoomId: json['chatRoomId'] is String
          ? json['chatRoomId']
          : json['chatRoomId']['_id'],
      senderId: json['senderId'] is String
          ? json['senderId']
          : json['senderId']['_id'],
      message: json['message'],
      messageType: json['messageType'] ?? 'text',
      isSeen: json['isSeen'] ?? false,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'message': message,
      'messageType': messageType,
      'isSeen': isSeen,
    };
  }

  bool isMine() {
    return senderId == authService.userId;
  }

  bool hasSameSenderWith(Message message) {
    return message.senderId == senderId;
  }
}
