import 'package:chat_app/app/models/message_model.dart';
import 'package:flutter/material.dart';

class OtherMessage extends StatelessWidget {
  final Message message;

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
          message.updatedAt.substring(11, 16),
          style: const TextStyle(fontSize: 11.0, color: Colors.black38),
        ),
      ],
    );
  }
}
