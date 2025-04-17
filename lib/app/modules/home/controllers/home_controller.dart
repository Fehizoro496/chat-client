import 'dart:convert';
import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/services/socket_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/discussion_model.dart';

class HomeController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final SocketService socketService = Get.find<SocketService>();
  List<Discussion> discussions = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchDiscussions();
  }

  Future<void> fetchDiscussions() async {
    isLoading = true;
    update();

    final token = authService.token;

    final response = await http.get(
      Uri.parse("http://localhost:5000/api/chats/rooms"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      // print(data);
      discussions = data.map((e) {
        return Discussion.fromJson(e);
      }).toList();
      // print(discussions.map((e) => e.lastMessage!.message));
      discussions.forEach((e) => socketService.joinRoom(e.id));
      update();
    }

    isLoading = false;
  }
}
