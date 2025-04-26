import 'package:chat_app/app/modules/discussion/views/widget/my_message.dart';
import 'package:chat_app/app/modules/discussion/views/widget/other_message.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/discussion_controller.dart';

class DiscussionView extends GetView<DiscussionController> {
  const DiscussionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiscussionController>(builder: (context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
          title: Text(
            controller.discussion.name ?? '',
            style: const TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
        ),
        body: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) => Container(
                        padding: (index > 0 &&
                                controller.messages[index].hasSameSenderWith(
                                    controller.messages[index - 1]))
                            ? const EdgeInsets.only(left: 24, right: 24, top: 5)
                            : const EdgeInsets.only(
                                left: 24, right: 24, top: 20),
                        child: Align(
                          alignment: (controller.messages[index].isMine())
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: (controller.messages[index].isMine())
                              ? MyMessage(message: controller.messages[index])
                              : OtherMessage(
                                  message: controller.messages[index]),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            onPressed: () => controller.toogleMoreActions(),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.black87,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding:
                                  EdgeInsets.zero, // Remove default padding
                            ),
                            child: Center(
                              child: Icon(
                                (!controller.moreActions)
                                    ? Icons.add
                                    : Icons.close,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        if (controller.moreActions)
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: controller.moreActions ? 1.0 : 0.0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.translationValues(
                                  controller.moreActions ? 0 : -20, 0, 0),
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 8),
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey[100],
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.image_outlined,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                        if (controller.moreActions)
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: controller.moreActions ? 1.0 : 0.0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.translationValues(
                                  controller.moreActions ? 0 : -20, 0, 0),
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 8),
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey[100],
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.attach_file,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                        Expanded(
                          child: TextField(
                            controller: controller.inputController,
                            minLines: 1,
                            maxLines: 2,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              hintText: 'Aa',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
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
                                backgroundColor: Colors.black87,
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
