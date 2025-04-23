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
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
          ],
          surfaceTintColor: Colors.transparent,
          title: Text(controller.discussion.name ?? ''),
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
                            ? const EdgeInsets.only(left: 14, right: 14, top: 5)
                            : const EdgeInsets.only(
                                left: 14, right: 14, top: 20),
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
                  SizedBox(
                    height: 70,
                    width: Get.width,
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(0),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 18.0,
                            )),
                        Expanded(
                          child: TextField(
                            controller: controller.inputController,
                            minLines: 1,
                            maxLines: 2,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              hintText: 'Aa',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              controller.sendMessage();
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.blue,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
