import 'package:chat_app/core/services/auth_service.dart';
import 'package:get/get.dart';

class MessageModel {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String senderName;
  String message;
  final String messageType; // 'text', 'image', 'file'
  List<String> seenBy;
  final String createdAt;
  final String updatedAt;
  final AuthService authService = Get.find<AuthService>();

  MessageModel({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.messageType,
    required this.seenBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      chatRoomId: json['chatRoomId'] is String
          ? json['chatRoomId']
          : json['chatRoomId']['_id'],
      senderId: json['senderId'] is String
          ? json['senderId']
          : json['senderId']['_id'],
      senderName: json['senderName'],
      message: json['message'],
      messageType: json['messageType'] ?? 'text',
      seenBy: List<String>.from(
          json['seenBy']?.map((x) => x is String ? x : x['_id']) ?? []),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'messageType': messageType,
      'seenBy': seenBy,
    };
  }

  bool isMine() {
    return senderId == authService.userId;
  }

  bool hasSameSenderWith(MessageModel message) {
    return message.senderId == senderId;
  }

  bool isToday() {
    return DateTime.now().difference(DateTime.parse(createdAt)).inDays == 0;
  }

  bool seen() {
    return seenBy.contains(Get.find<AuthService>().userId);
  }

  void markAsSeen() {
    final userId = Get.find<AuthService>().userId!;
    if (!seenBy.contains(userId)) seenBy.add(userId);
  }
}
