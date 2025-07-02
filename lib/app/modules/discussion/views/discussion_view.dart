import 'dart:io';

import 'package:chat_app/app/constant.dart';
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.scrollToBottom();
      });
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.95),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
                (controller.selectedImage == null)
                    ? Icons.arrow_back_ios_new
                    : Icons.close,
                color: Colors.black87),
            onPressed: () {
              // controller.disposeScrollController();
              if (controller.selectedImage == null) {
                Get.offNamed('/home');
              } else {
                controller.hideImage();
              }
            },
          ),
          title: Text(
            controller.discussion.name ?? '',
            style: const TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
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
                        child: GestureDetector(
                            onTap: () {
                              if (controller.messages[index].messageType ==
                                  'image') {
                                controller.showImage(
                                    controller.messages[index].message);
                              }
                            },
                            child: (controller.messages[index].isMine())
                                ? MyMessage(message: controller.messages[index])
                                : OtherMessage(
                                    message: controller.messages[index],
                                    showSender: controller
                                            .discussion.isGroupChat &&
                                        (index == 0 ||
                                            !controller.messages[index]
                                                .hasSameSenderWith(controller
                                                    .messages[index - 1])),
                                  )),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.inputController,
                          minLines: 1,
                          maxLines: 2,
                          enabled: controller.pickedImage == null,
                          // onTap: () => controller.closeMoreActions(),
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              width: 30,
                              height: 30,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
            if (controller.pickedImage != null)
              Positioned(
                bottom: 60,
                left: 0,
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, bottom: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(File(controller.pickedImage!.path),
                          fit: BoxFit.cover,
                          height: 75,
                          width: 75,
                          alignment: Alignment.center),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: ElevatedButton(
                        onPressed: () => controller.removeImage(),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.black38,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            if (controller.selectedImage != null)
              Container(
                color: Colors.white,
                height: Get.height - 124,
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.network(
                    filterQuality: FilterQuality.medium,
                    'http://$LOCAL_URL:5000${controller.selectedImage}',
                    // height: 100,
                    // width: Get.width,
                    fit: BoxFit.contain,
                  ),
                ),
              )
          ],
        ),
      );
    });
  }
}
