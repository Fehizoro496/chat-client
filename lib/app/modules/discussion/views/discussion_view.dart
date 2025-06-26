import 'package:chat_app/app/modules/discussion/views/widget/my_message.dart';
import 'package:chat_app/app/modules/discussion/views/widget/other_message.dart';
import 'package:chat_app/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/discussion_controller.dart';

class DiscussionView extends GetView<DiscussionController> {
  const DiscussionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiscussionController>(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.scrollToBottom();
      });
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.95),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
            onPressed: () {
              // controller.disposeScrollController();
              Get.offNamed('/home');
            },
          ),
          title: Text(
            controller.discussion.name ?? '',
            style: const TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) => Container(
                  padding: (index > 0 &&
                          controller.messages[index].hasSameSenderWith(
                              controller.messages[index - 1]))
                      ? const EdgeInsets.only(left: 24, right: 24, top: 5)
                      : const EdgeInsets.only(left: 24, right: 24, top: 10),
                  child: Align(
                    alignment: (controller.messages[index].isMine())
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: (controller.messages[index].isMine())
                        ? MyMessage(message: controller.messages[index])
                        : OtherMessage(
                            message: controller.messages[index],
                            showSender: controller.discussion.isGroupChat &&
                                (index == 0 ||
                                    !controller.messages[index]
                                        .hasSameSenderWith(
                                            controller.messages[index - 1])),
                          ),
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.inputController,
                      minLines: 1,
                      maxLines: 2,
                      // onTap: () => controller.closeMoreActions(),
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                            onPressed: () => controller.toogleMoreActions(),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding:
                                  EdgeInsets.zero, // Remove default padding
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        hintText: 'Aa',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 40,
                    height: 40,
                    child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: const CircleBorder(),
                        ),
                        onPressed: () => controller.sendMessage(),
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
