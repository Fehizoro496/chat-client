import 'dart:ui';

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
      body: Stack(
        children: [
          GetBuilder<HomeController>(
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
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: (kToolbarHeight + 15)),
                itemCount: controller.discussions.length,
                itemBuilder: (context, index) {
                  final discussion = controller.discussions[index];
                  final title = discussion.name ?? 'Unnamed Group';
                  String subtitle = !(discussion.lastMessage == null)
                      ? (discussion.lastMessage!.isMine())
                          ? 'you : '
                          : ''
                      : '';
                  subtitle = subtitle +
                      (discussion.lastMessage?.message ?? 'No messages yet');

                  return Card(
                    elevation: discussion.checked() ? 2 : 1,
                    color: Colors.grey[discussion.checked() ? 200 : 50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      leading: CircleAvatar(
                        backgroundColor: Colors.black87,
                        child: Icon(
                          (discussion.isGroupChat)
                              ? Icons.groups
                              : Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        title,
                        style: TextStyle(
                          fontWeight: discussion.checked()
                              ? FontWeight.w600
                              : FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        subtitle,
                        style: TextStyle(
                          fontWeight: discussion.checked()
                              ? FontWeight.w400
                              : FontWeight.w500,
                          color: Colors.black54,
                        ),
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: AppBar(
                  backgroundColor: Colors.white10.withOpacity(0.5),
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  ],
                  title: const Text(
                    'Discussions',
                    style: TextStyle(color: Colors.black87),
                  ),
                  centerTitle: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
