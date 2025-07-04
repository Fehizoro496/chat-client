import 'dart:convert';
import 'package:chat_app/app/models/message_model.dart';
import 'package:chat_app/app/models/user_model.dart';
import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/services/socket_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/app/models/discussion_model.dart';
import 'package:chat_app/app/constant.dart';

class HomeController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final SocketService socketService = Get.find<SocketService>();
  List<Discussion> discussions = [];
  bool isLoading = false;

  @override
  void onInit() async {
    await fetchDiscussions();
    socketService.onDiscussionMessage = handleNewMessage;
    super.onInit();
  }

  Future<String> fetchDiscussionName(Discussion discussion) async {
    if (discussion.isGroupChat) {
      return discussion.name ?? 'still unnamed';
    }

    String otherParticipantId = discussion.participantIds
        .where((element) => element != authService.userId)
        .first;

    final response = await http.get(
      Uri.parse("http://$LOCAL_URL:5000/api/users/$otherParticipantId"),
      headers: {
        'Authorization': 'Bearer ${authService.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      User user = User.fromJson(data);
      return user.username;
    }
    return 'still unnamed';
  }

  Future<String> fetchUserName(String userId) async {
    final response = await http.get(
      Uri.parse("http://$LOCAL_URL:5000/api/users/$userId"),
      headers: {
        'Authorization': 'Bearer ${authService.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      User user = User.fromJson(data);
      return user.username;
    }
    return 'Unknown User';
  }

  Future<void> fetchDiscussions() async {
    isLoading = true;
    update();

    final token = authService.token;

    http.get(
      Uri.parse("http://$LOCAL_URL:5000/api/chats/rooms"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).then((response) async {
      final List data = jsonDecode(response.body);
      // print(data);
      discussions = data.map((e) {
        return Discussion.fromJson(e);
      }).toList();
      discussions = await Future.wait(discussions.map((e) async {
        e.name = await fetchDiscussionName(e);
        return e;
      }));
      for (var e in discussions) {
        socketService.joinRoom(e.id);
      }
      _sortDiscussion();
      update();
    }).catchError((onError) {});

    isLoading = false;
  }

  Future<void> fetchDiscussions2() async {
    isLoading = true;
    update();

    final token = authService.token;

    final response = await http.get(
      Uri.parse("http://$LOCAL_URL:5000/api/chats/rooms"),
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
      discussions = await Future.wait(discussions.map((e) async {
        e.name = await fetchDiscussionName(e);
        return e;
      }));
      for (var e in discussions) {
        socketService.joinRoom(e.id);
      }
      update();
    }

    isLoading = false;
  }

  handleNewMessage(MessageModel messageData) {
    final chatRoomId = messageData.chatRoomId;

    // Find the discussion and update lastMessage
    final index = discussions.indexWhere((d) => d.id == chatRoomId);
    if (index != -1) {
      discussions[index].lastMessage = messageData;
      _sortDiscussion();
    }
  }

  Future<void> _sortDiscussion() async {
    discussions.sort((a, b) {
      if (a.lastMessage == null) {
        return 1;
      }
      if (b.lastMessage == null) {
        return -1;
      }
      return DateTime.parse(b.lastMessage!.createdAt)
          .compareTo(DateTime.parse(a.lastMessage!.createdAt));
    });
    print('sort');
    print(discussions.map((e) => e.name));
    update();
  }

  void logout() {
    Get.offAllNamed('/login');
    for (var e in discussions) {
      socketService.leaveRoom(e.id);
    }
    authService.logout();
  }
}
