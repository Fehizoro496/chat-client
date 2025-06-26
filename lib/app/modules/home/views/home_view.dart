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
      appBar: AppBar(
        leading: Container(),
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
      backgroundColor: Colors.white,
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
            itemCount: controller.discussions.length,
            padding: const EdgeInsets.only(top: 10.0),
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

              return Column(
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    // const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    leading: CircleAvatar(
                      child: Icon(
                        (discussion.isGroupChat) ? Icons.groups : Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: discussion.checked()
                            ? FontWeight.w500
                            : FontWeight.w600,
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
                        ? Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                discussion.lastMessage!.isToday()
                                    ? formatGMTplus3(
                                        discussion.lastMessage!.createdAt)
                                    : formatDate(
                                        discussion.lastMessage!.createdAt),
                                // .replaceAll('-', '/'),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                              (!discussion.lastMessage!.seen())
                                  ? Container(
                                      margin: const EdgeInsets.only(left: 5.0),
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0))),
                                    )
                                  : Container(
                                      width: 10,
                                    ),
                            ],
                          )
                        : null,
                    onTap: () {
                      Get.toNamed('/discussion',
                          arguments: {'discussion': discussion});
                    },
                  ),
                  if (index < controller.discussions.length - 1)
                    const Divider(
                      color: Colors.black12,
                      height: 1.0,
                      indent: kToolbarHeight,
                      endIndent: 16.0,
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
