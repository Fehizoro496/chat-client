import 'dart:convert';

import 'package:chat_app/app/constant.dart';
import 'package:chat_app/app/models/message_model.dart';
import 'package:chat_app/app/models/user_model.dart';
import 'package:chat_app/app/utils/hour_format.dart';
import 'package:chat_app/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OtherMessage extends StatelessWidget {
  final MessageModel message;
  final bool showSender;
  final AuthService authService = Get.find();

  OtherMessage({super.key, required this.message, required this.showSender});

  Future<String> fetchUserName(String userId) async {
    final response = await http.get(
      Uri.parse("http://$LOCAL_URL:5000/api/users/$userId"),
      headers: {
        'Authorization': 'Bearer ${authService.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      User user = User.fromJson(data);
      return user.username;
    }
    return 'Unknown User';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showSender)
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: FutureBuilder<String>(
                future: fetchUserName(message.senderId),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? "",
                    style: const TextStyle(
                      fontSize: 11.0,
                      color: Colors.black54,
                    ),
                  );
                }),
          ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            (message.messageType == 'text')
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                          Colors.grey[100], // Updated to match login_view.dart
                    ),
                    child: Text(
                      message.message,
                      style: const TextStyle(
                        color:
                            Colors.black87, // Updated to match login_view.dart
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      filterQuality: FilterQuality.medium,
                      'http://$LOCAL_URL:5000${message.message}',
                      // height: 100,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
            const SizedBox(
              width: 6.0,
            ),
            Text(
              formatGMTplus3(message.updatedAt),
              style: const TextStyle(
                fontSize: 10.0,
                color: Colors.black54,
              ), // Updated
            ),
          ],
        ),
      ],
    );
  }
}
