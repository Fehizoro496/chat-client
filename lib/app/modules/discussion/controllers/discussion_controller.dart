import 'dart:convert';
import 'dart:io';
import 'package:chat_app/app/models/discussion_model.dart';
import 'package:chat_app/core/services/notification_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/app/models/message_model.dart';
import 'package:chat_app/app/constant.dart';
import 'package:image_picker/image_picker.dart';

class DiscussionController extends GetxController {
  Discussion discussion = Get.arguments['discussion'];
  final ScrollController scrollController = ScrollController();
  final AuthService authService = Get.find<AuthService>();
  final SocketService socketService = Get.find<SocketService>();
  final NotificationService notificationService =
      Get.find<NotificationService>();
  List<MessageModel> messages = [];
  TextEditingController inputController = TextEditingController();
  bool isLoading = true;
  bool moreActions = false;
  XFile? pickedImage;
  String? selectedImage;

  @override
  void onInit() async {
    super.onInit();
    await fetchMessages();
    socketService.onMessageReceived = handleIncomingMessage;
    isLoading = false;
    markAsSeen();
    update();
  }

  @override
  void onClose() {
    markAsSeen();
    super.onClose();
  }

  void showImage(String image) {
    selectedImage = image;
    update();
  }

  void hideImage() {
    selectedImage = null;
    update();
  }

  void disposeScrollController() {
    if (scrollController.hasClients) {
      scrollController.dispose();
    }
  }

  void markAsSeen() async {
    if (discussion.lastMessage != null && (!discussion.lastMessage!.seen())) {
      final response = await http.put(
        Uri.parse(
            "http://$LOCAL_URL:5000/api/chats/seen/${discussion.lastMessage!.id}"),
        headers: {
          'Authorization': 'Bearer ${authService.token}',
        },
      );
      print(response.body);
      if (response.statusCode == 200) discussion.lastMessage!.markAsSeen();
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  // void toogleMoreActions() {
  //   moreActions = !moreActions;
  //   update();
  // }
  void removeImage() {
    pickedImage = null;
    update();
  }

  void toogleMoreActions() {
    Get.bottomSheet(BottomSheet(
        // enableDrag: true,
        onClosing: () {},
        builder: (context) {
          return SizedBox(
            height: kToolbarHeight * 2 + 10,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.black12.withOpacity(.30),
                  ),
                  width: 70,
                  height: 5,
                ),
                ListTile(
                  onTap: () {
                    handleImagePicker();
                    Get.back();
                  },
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.image_outlined,
                      size: 18,
                    ),
                  ),
                  title: const Text(
                    'Send an image',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.attach_file,
                      size: 18,
                    ),
                  ),
                  title: Text(
                    'Send a file',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        }));
  }

  void closeMoreActions() {
    moreActions = false;
    update();
  }

  void handleIncomingMessage(MessageModel data) {
    messages.add(data);
    update(); // Trigger UI refresh
  }

  Future<void> fetchMessages() async {
    final response = await http.get(
      Uri.parse("http://$LOCAL_URL:5000/api/chats/messages/${discussion.id}"),
      headers: {
        'Authorization': 'Bearer ${authService.token}',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      messages = data.map((e) {
        return MessageModel.fromJson(e);
      }).toList();
    }
  }

  Future<void> handleImagePicker() async {
    final ImagePicker picker = ImagePicker();
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    update();
  }

  void sendMessage() {
    if (pickedImage != null) {
      uploadImage(File(pickedImage!.path)).then((imageUrl) {
        if (imageUrl != null) {
          socketService.sendMessage({
            'chatRoomId': discussion.id,
            'senderId': authService.userId,
            'senderName': authService.userName,
            'message': imageUrl,
            'seenBy': [authService.userId],
            'messageType': 'image'
          });
          pickedImage = null; // Reset the picked image
          update();
          scrollToBottom();
        } else {
          print("Failed to upload image");
        }
        pickedImage = null;
        update();
        scrollToBottom();
      });
    } else if (inputController.text.trim().isNotEmpty) {
      socketService.sendMessage({
        'chatRoomId': discussion.id,
        'senderId': authService.userId,
        'senderName': authService.userName,
        'message': inputController.text,
        'seenBy': [authService.userId],
        'messageType': 'text'
      });
      inputController.clear();
      update();
      scrollToBottom();
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://$LOCAL_URL:5000/upload'),
    );

    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final body = await http.Response.fromStream(response);
      final data = jsonDecode(body.body);
      return data["imageUrl"];
    } else {
      print("Erreur d'upload");
      return null;
    }
  }

  void showNotification() {
    notificationService.showNotification(
      title: "test title",
      body: 'test body',
    );
  }
}
