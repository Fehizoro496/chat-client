// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// import '../controllers/home_controller.dart';

// class HomeView extends GetView<HomeController> {
//   const HomeView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           surfaceTintColor: Colors.transparent,
//           title: const Text(
//             'Discussions',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//           ),
//           actions: [
//             IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
//             const SizedBox(
//               width: 14,
//             )
//           ],
//         ),
//         body: ListView.builder(
//             itemCount: controller.discussions.length,
//             itemBuilder: (context, index) {
//               print(index);
//               print(controller.discussions.length);
//               final discussion = controller.discussions[index];
//               final currentUserId = controller.authService.userId;

//               // Determine the other participant (if private chat)
//               final otherUserId = discussion.participantIds.firstWhere(
//                   (id) => id != currentUserId,
//                   orElse: () => 'Unknown');

//               final title = discussion.isGroupChat
//                   ? discussion.name ?? 'Unnamed Group'
//                   : 'Chat with $otherUserId';

//               final subtitle = discussion.lastMessage != null
//                   ? discussion.lastMessage!.message
//                   : 'No messages yet';
//               return ListTile(
//                 leading: Container(
//                     decoration: const BoxDecoration(color: Colors.blue),
//                     child: const Icon(Icons.person)),
//                 onTap: () {
//                   Get.toNamed('/discussion',
//                       arguments: {'discussion': controller.discussions[index]});
//                 },
//                 title: Text(title),
//                 subtitle: Text(subtitle),
//                 // "${controller.discussions[index].messages.last.auteur == "me" ? "me : " : ""}${controller.discussions[index].messages.last.texte}"),
//               );
//             }));
//   }
// }

import 'package:chat_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../controllers/himce.dart';
// import 'chat_page.dart';

class HomeView extends StatelessWidget {
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
                  : 'Chat with $otherUserId';

              final subtitle = discussion.lastMessage != null
                  ? discussion.lastMessage!.message
                  : 'No messages yet';

              return ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                onTap: () {
                  // Get.to(() => ChatPage(
                  //       roomId: discussion.id,
                  //       receiverId: discussion.isGroupChat ? '' : otherUserId,
                  //       receiverName: title,
                  //     ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
