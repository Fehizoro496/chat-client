import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscussionController extends GetxController {
  //TODO: Implement DiscussionController
  // late DiscussionModel discussion;
  TextEditingController inputController = TextEditingController();
  // late final BuildContext context;

  @override
  void onInit() {
    super.onInit();
    // discussion = Get.arguments['discussion'];
    // discussion = DiscussionModel('Friend temp', [
    //   MessageModel(
    //       auteur: "Friend temp", texte: "Lorem Ipsum Dolor Sit Amet farany "),
    //   MessageModel(auteur: "me", texte: "Lorem Ipsum Dolor Sit Amet"),
    //   MessageModel(auteur: "Friend temp", texte: "Lorem Ipsum Dolor Sit Amet"),
    //   MessageModel(auteur: "me", texte: "Lorem Ipsum Dolor Sit Amet"),
    // ]);
  }

  // void sendMessage() {
  //   if (inputController.text.isNotEmpty) {
  //     discussion.messages
  //         .add(MessageModel(auteur: "me", texte: inputController.text));
  //     inputController.clear();
  //   }
  //   update();
  // }
}
