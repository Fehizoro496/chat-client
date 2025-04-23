import 'package:chat_app/app/models/message_model.dart';
import 'package:chat_app/app/utils/hour_format.dart';
import 'package:flutter/material.dart';

class OtherMessage extends StatelessWidget {
  final MessageModel message;

  const OtherMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade200,
          ),
          child: Text(
            message.message,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          width: 6.0,
        ),
        Text(
          formatGMTplus3(message.updatedAt),
          style: const TextStyle(fontSize: 11.0, color: Colors.black38),
        ),
      ],
    );
  }
}
