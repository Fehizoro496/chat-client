// import 'package:chat_app/app/models/discussion_model.dart';
// import 'package:chat_app/app/models/message_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/discussion_controller.dart';

// class DiscussionView extends GetView<DiscussionController> {
//   const DiscussionView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<DiscussionController>(builder: (context) {
//       return Scaffold(
//         appBar: AppBar(
//           actions: [
//             IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
//           ],
//           surfaceTintColor: Colors.transparent,
//           title: Text(controller.discussion.contact),
//           centerTitle: true,
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: controller.discussion.messages.length,
//                 // itemBuilder: (context, index) => ListTile(
//                 //   tileColor: (controller.discussion.messages[index].auteur == 'me')
//                 //       ? Colors.blue[50]
//                 //       : Colors.white,
//                 //   title: Text(controller.discussion.messages[index].auteur),
//                 //   subtitle: Text(controller.discussion.messages[index].texte),
//                 // ),
//                 itemBuilder: (context, index) => Container(
//                   padding: (index > 0 &&
//                           controller.discussion.messages[index - 1].auteur ==
//                               controller.discussion.messages[index].auteur)
//                       ? const EdgeInsets.only(left: 14, right: 14, top: 5)
//                       : const EdgeInsets.only(left: 14, right: 14, top: 20),
//                   child: Align(
//                     alignment:
//                         (controller.discussion.messages[index].auteur == 'me')
//                             ? Alignment.topRight
//                             : Alignment.topLeft,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 14, vertical: 8),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: (controller.discussion.messages[index].auteur ==
//                                 'me')
//                             ? Colors.blue[200]
//                             : Colors.grey.shade200,
//                       ),
//                       child: Text(controller.discussion.messages[index].texte),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 70,
//               width: Get.width,
//               child: Row(
//                 children: [
//                   ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         shape: const CircleBorder(),
//                         padding: const EdgeInsets.all(0),
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                       ),
//                       child: const Icon(
//                         Icons.add,
//                         size: 18.0,
//                       )),
//                   Expanded(
//                       child: TextField(
//                     controller: controller.inputController,
//                     decoration: const InputDecoration(
//                         hintText: 'Write message ...',
//                         border: InputBorder.none),
//                   )),
//                   IconButton(
//                       onPressed: () {
//                         controller.sendMessage();
//                       },
//                       icon: const Icon(
//                         Icons.send,
//                         color: Colors.blue,
//                       ))
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

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
            // title: Text(controller.discussion.contact),
            title: Text('controller.discussion.contact'),
            centerTitle: true,
          ),
          body: Center(
            child: Text(('data')),
          ));
    });
  }
}
