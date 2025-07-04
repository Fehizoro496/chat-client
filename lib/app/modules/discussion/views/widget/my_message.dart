import 'package:chat_app/app/utils/hour_format.dart';
import 'package:chat_app/app/models/message_model.dart';
import 'package:chat_app/app/constant.dart';
import 'package:flutter/material.dart';

class MyMessage extends StatelessWidget {
  final MessageModel message;

  const MyMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          formatGMTplus3(message.updatedAt),
          style:
              const TextStyle(fontSize: 10, color: Colors.black54), // Updated
        ),
        const SizedBox(
          width: 6.0,
        ),
        (message.messageType == 'text')
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue, // Updated to match login_view.dart
                ),
                child: Text(
                  message.message,
                  style: const TextStyle(
                    color: Colors
                        .white, // No change, already matches login_view.dart
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
      ],
    );
  }
}
