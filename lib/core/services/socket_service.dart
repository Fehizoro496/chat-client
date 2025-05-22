import 'package:chat_app/app/models/message_model.dart';
import 'package:chat_app/app/constant.dart';
import 'package:chat_app/core/services/notification_service.dart';
import 'package:get/get.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  late IO.Socket _socket;
  late NotificationService notificationService =
      Get.find<NotificationService>();

  Function(MessageModel messageData)? onMessageReceived;
  Function(MessageModel messageData)? onDiscussionMessage;
  Future<SocketService> init() async {
    _socket = IO.io(
      'http://$LOCAL_URL:5000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket.onConnect((_) {
      print('✅ Socket connected');
    });

    _socket.onDisconnect((_) {
      print('🔌 Socket disconnected');
    });

    _socket.on('receive_message', (data) {
      print('📩 Message received: $data');

      // Notify messages (if in MessagesController)
      onMessageReceived?.call(MessageModel.fromJson(data));

      // Notify discussions
      onDiscussionMessage?.call(MessageModel.fromJson(data));

      //show notification
      notificationService.showNotification(
        title: "test title",
        body: 'test body',
      );
    });

    _socket.connect();
    return this;
  }

  void joinRoom(String roomId) {
    print('👥 Joining room: $roomId');
    _socket.emit('join_room', roomId);
  }

  void leaveRoom(String roomId) {
    print('🚪 Leaving room: $roomId');
    _socket.emit('leave_room',
        roomId); // Optional: You can implement this backend-side too
  }

  void sendMessage(Map<String, dynamic> messageData) {
    print('📤 Sending message: $messageData');
    _socket.emit('send_message', messageData);
  }

  void disconnect() {
    _socket.disconnect();
  }

  void reconnect() {
    _socket.connect();
  }
}
