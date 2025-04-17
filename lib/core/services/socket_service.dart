import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  late IO.Socket _socket;

  Function(Map<String, dynamic> messageData)? onMessageReceived;

  Future<SocketService> init() async {
    _socket = IO.io(
      'http://localhost:5000',
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
      if (onMessageReceived != null) {
        onMessageReceived!(Map<String, dynamic>.from(data));
      }
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
