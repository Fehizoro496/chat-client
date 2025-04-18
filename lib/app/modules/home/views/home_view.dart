import 'package:chat_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discussions')),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.discussions.isEmpty) {
            return const Center(child: Text('No discussions yet.'));
          }

          return ListView.builder(
            itemCount: controller.discussions.length,
            itemBuilder: (context, index) {
              final discussion = controller.discussions[index];
              final currentUserId = controller.authService.userId;

              // Determine the other participant (if private chat)
              final otherUserId = discussion.participantIds.firstWhere(
                  (id) => id != currentUserId,
                  orElse: () => 'Unknown');

              final title = discussion.isGroupChat
                  ? discussion.name ?? 'Unnamed Group'
                  : otherUserId;

              final subtitle =
                  discussion.lastMessage?.message ?? 'No messages yet';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                      (discussion.isGroupChat) ? Icons.group : Icons.person,
                      color: Colors.black54),
                ),
                title: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(subtitle),
                onTap: () {
                  Get.toNamed('/discussion',
                      arguments: {'discussion': discussion});
                },
              );
            },
          );
        },
      ),
    );
  }
}
