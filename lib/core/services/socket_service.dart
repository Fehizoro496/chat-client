import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef OnMessageReceived = void Function(Map<String, dynamic> data);

class SocketService {
  late IO.Socket _socket;
  bool _connected = false;

  final String userId;

  SocketService({required this.userId});

  void connect() {
    _socket = IO.io('http://<your-ip>:3000', {
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.onConnect((_) {
      _connected = true;
      print('🟢 Socket connected');
    });

    _socket.onDisconnect((_) {
      _connected = false;
      print('🔴 Socket disconnected');
    });
  }

  void joinRoom(String roomId) {
    if (_connected) {
      _socket.emit('join_room', roomId);
    }
  }

  void sendMessage({
    required String roomId,
    required String message,
    required String messageType,
  }) {
    _socket.emit('send_message', {
      'chatRoomId': roomId,
      'senderId': userId,
      'message': message,
      'messageType': messageType,
    });
  }

  void listenToMessages(OnMessageReceived callback) {
    _socket.on('receive_message',
        (dynamic data) => callback(Map<String, dynamic>.from(data)));
  }

  void disconnect() {
    _socket.disconnect();
  }
}
