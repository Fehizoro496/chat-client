import 'package:chat_app/app/modules/home/controllers/home_controller.dart';
import 'package:chat_app/app/utils/hour_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Discussions'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.discussions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 60, color: Colors.black87),
                  SizedBox(height: 16),
                  Text(
                    'No discussions yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.discussions.length,
            itemBuilder: (context, index) {
              final discussion = controller.discussions[index];
              final title = discussion.name ?? 'Unnamed Group';
              String subtitle = (!discussion.lastMessage.isNull)
                  ? (discussion.lastMessage!.isMine())
                      ? 'you : '
                      : ''
                  : '';
              subtitle = subtitle +
                  (discussion.lastMessage?.message ?? 'No messages yet');

              return Card(
                elevation: 2,
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.black87,
                    child: Icon(
                      (discussion.isGroupChat) ? Icons.groups : Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    subtitle,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: (discussion.lastMessage != null)
                      ? Text(
                          formatGMTplus3(discussion.lastMessage!.createdAt),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        )
                      : null,
                  onTap: () {
                    Get.toNamed('/discussion',
                        arguments: {'discussion': discussion});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
