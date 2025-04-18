import 'package:chat_app/app/models/message_model.dart';

class Discussion {
  final String id;
  final List<String> participantIds; // list of user IDs
  final bool isGroupChat;
  final String? name;
  Message? lastMessage;
  final String createdAt;
  String updatedAt;

  Discussion({
    required this.id,
    required this.participantIds,
    required this.isGroupChat,
    this.name,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
      id: json['_id'],
      participantIds: List<String>.from(
        (json['participants'] as List)
            .map((e) => e is String ? e : e['_id']), // in case it's populated
      ),
      isGroupChat: json['isGroupChat'] ?? false,
      name: json['name'],
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
